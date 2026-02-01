-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. USERS
CREATE TYPE user_role AS ENUM ('worker', 'supervisor', 'admin');

CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    role user_role NOT NULL DEFAULT 'worker',
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    phone TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS: Public read for basic info? Or restricted.
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public profiles are viewable by everyone" ON users FOR SELECT USING (true);
CREATE POLICY "Users can insert their own profile" ON users FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE WITH CHECK (auth.uid() = id);

-- 2. PROJECTS
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    geofence_lat DOUBLE PRECISION NOT NULL,
    geofence_long DOUBLE PRECISION NOT NULL,
    geofence_radius_meters DOUBLE PRECISION NOT NULL DEFAULT 100.0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated users can read projects" ON projects FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage projects" ON projects FOR ALL USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'));

-- 3. HIERARCHY NODES (Ilot / Bloc / Appartement)
CREATE TYPE hierarchy_type AS ENUM ('ilot', 'bloc', 'appartement');

CREATE TABLE hierarchy_nodes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    parent_id UUID REFERENCES hierarchy_nodes(id) ON DELETE CASCADE,
    type hierarchy_type NOT NULL,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE hierarchy_nodes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated users can read hierarchy" ON hierarchy_nodes FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage hierarchy" ON hierarchy_nodes FOR ALL USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'));

-- 4. TASK CATALOG
CREATE TYPE unit_type AS ENUM ('m2', 'ml', 'unit');

CREATE TABLE task_catalog (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    unit_type unit_type NOT NULL,
    base_price NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE task_catalog ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated users can read catalog" ON task_catalog FOR SELECT USING (auth.role() = 'authenticated');

-- 5. TASKS
CREATE TYPE task_status AS ENUM ('pending', 'validated', 'rejected');

CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    local_id TEXT, -- For offline creation reference
    title TEXT NOT NULL,
    description TEXT,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    hierarchy_node_id UUID REFERENCES hierarchy_nodes(id),
    task_catalog_id UUID REFERENCES task_catalog(id),
    negotiated_price NUMERIC(10, 2), -- Nullable override
    assigned_group_id UUID, -- Could be a group table, skipping for now
    status task_status DEFAULT 'pending',
    completion_percentage INTEGER DEFAULT 0 CHECK (completion_percentage BETWEEN 0 AND 100),
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated users can read tasks" ON tasks FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Supervisors can insert tasks" ON tasks FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('supervisor', 'admin')));
CREATE POLICY "Supervisors can update tasks" ON tasks FOR UPDATE USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('supervisor', 'admin')));

-- 6. TASK MEDIA
CREATE TYPE media_type AS ENUM ('image', 'audio');

CREATE TABLE task_media (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
    type media_type NOT NULL,
    storage_url TEXT NOT NULL,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE task_media ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated users can read media" ON task_media FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Supervisors can insert media" ON task_media FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('supervisor', 'admin')));

-- 7. ATTENDANCE LOGS
CREATE TABLE attendance_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    supervisor_id UUID REFERENCES users(id),
    date DATE NOT NULL,
    gps_lat DOUBLE PRECISION NOT NULL,
    gps_long DOUBLE PRECISION NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE attendance_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated users can read logs" ON attendance_logs FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Supervisors can create logs" ON attendance_logs FOR INSERT WITH CHECK (auth.uid() = supervisor_id);

-- 8. ATTENDANCE ENTRIES
CREATE TYPE attendance_status AS ENUM ('present', 'absent', 'half-day');

CREATE TABLE attendance_entries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    attendance_log_id UUID REFERENCES attendance_logs(id) ON DELETE CASCADE,
    worker_id UUID REFERENCES users(id),
    status attendance_status NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE attendance_entries ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated users can read entries" ON attendance_entries FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Supervisors can create entries" ON attendance_entries FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM attendance_logs WHERE id = attendance_log_id AND supervisor_id = auth.uid()));

-- 9. AUDIT LOGS
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    actor_id UUID REFERENCES users(id),
    action TEXT NOT NULL,
    entity_table TEXT,
    entity_id UUID,
    timestamp TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
-- Only admins usually read audit logs
CREATE POLICY "Admins can read audit logs" ON audit_logs FOR SELECT USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'));
