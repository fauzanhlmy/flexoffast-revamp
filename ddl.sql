CREATE DATABASE BlogManagement;
USE BlogManagement;

-- Tabel untuk menyimpan informasi tentang kategori atau tag
CREATE TABLE Categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50)
);

-- Tabel untuk menyimpan informasi tentang blog/news
CREATE TABLE Blogs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    published_at DATETIME,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(id)
);

-- Tabel untuk menyimpan tag yang dapat digunakan oleh blog/news
CREATE TABLE Tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50)
);

-- Tabel relasi many-to-many antara Blogs dan Tags
CREATE TABLE BlogTags (
    blog_id INT,
    tag_id INT,
    PRIMARY KEY (blog_id, tag_id),
    FOREIGN KEY (blog_id) REFERENCES Blogs(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES Tags(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50)
);

-- Tabel untuk manajemen pengguna
CREATE TABLE Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('admin', 'editor', 'author') NOT NULL DEFAULT 'author',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50)
);

-- Tabel untuk menyimpan informasi profil perusahaan
CREATE TABLE CompanyProfile (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),
    linkedin VARCHAR(255),
    whatsapp VARCHAR(20),
    facebook VARCHAR(255),
    youtube VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50)
);

-- Index untuk mempercepat pencarian berdasarkan tanggal publish
CREATE INDEX idx_published_at ON Blogs(published_at);

// database/migrations/2024_01_06_000000_create_categories_table.php
Schema::create('categories', function (Blueprint $table) {
    $table->id();
    $table->string('name', 50)->unique();
    $table->string('description', 255)->nullable();
    $table->timestamps();
    $table->string('created_by', 50)->nullable();
    $table->string('updated_by', 50)->nullable();
});

// database/migrations/2024_01_06_000001_create_blogs_table.php
Schema::create('blogs', function (Blueprint $table) {
    $table->id();
    $table->string('title', 255);
    $table->text('content');
    $table->string('image_url', 255)->nullable();
    $table->timestamp('created_at')->useCurrent();
    $table->timestamp('updated_at')->useCurrent()->useCurrentOnUpdate();
    $table->dateTime('published_at')->nullable();
    $table->string('created_by', 50)->nullable();
    $table->string('updated_by', 50)->nullable();
    $table->foreignId('category_id')->constrained('categories')->onDelete('cascade');
});

// database/migrations/2024_01_06_000002_create_tags_table.php
Schema::create('tags', function (Blueprint $table) {
    $table->id();
    $table->string('name', 50)->unique();
    $table->timestamps();
    $table->string('created_by', 50)->nullable();
    $table->string('updated_by', 50)->nullable();
});

// database/migrations/2024_01_06_000003_create_blog_tags_table.php
Schema::create('blog_tags', function (Blueprint $table) {
    $table->foreignId('blog_id')->constrained('blogs')->onDelete('cascade');
    $table->foreignId('tag_id')->constrained('tags')->onDelete('cascade');
    $table->primary(['blog_id', 'tag_id']);
    $table->timestamps();
    $table->string('created_by', 50)->nullable();
    $table->string('updated_by', 50)->nullable();
});

// database/migrations/2024_01_06_000004_create_users_table.php
Schema::create('users', function (Blueprint $table) {
    $table->id();
    $table->string('username', 50)->unique();
    $table->string('password_hash', 255);
    $table->string('email', 100)->unique();
    $table->enum('role', ['admin', 'editor', 'author'])->default('author');
    $table->timestamps();
    $table->string('created_by', 50)->nullable();
    $table->string('updated_by', 50)->nullable();
});

// database/migrations/2024_01_06_000005_create_company_profile_table.php
Schema::create('company_profile', function (Blueprint $table) {
    $table->id();
    $table->string('company_name', 255);
    $table->string('email', 100);
    $table->string('address', 255)->nullable();
    $table->string('phone', 20)->nullable();
    $table->string('linkedin', 255)->nullable();
    $table->string('whatsapp', 20)->nullable();
    $table->string('facebook', 255)->nullable();
    $table->string('youtube', 255)->nullable();
    $table->timestamps();
    $table->string('created_by', 50)->nullable();
    $table->string('updated_by', 50)->nullable();
});

// database/migrations/2024_01_06_000006_create_blog_images_table.php
Schema::create('blog_images', function (Blueprint $table) {
    $table->id();
    $table->foreignId('blog_id')->constrained('blogs')->onDelete('cascade');
    $table->string('image_url', 255);
    $table->string('alt_text', 255)->nullable();
    $table->integer('order')->default(0);
    $table->timestamps();
    $table->string('created_by', 50)->nullable();
    $table->string('updated_by', 50)->nullable();
});


// database/seeders/CategorySeeder.php
DB::table('categories')->insert([
    ['name' => 'Technology', 'description' => 'All about technology updates', 'created_by' => 'system'],
    ['name' => 'Health', 'description' => 'Health and wellness articles', 'created_by' => 'system'],
    ['name' => 'Lifestyle', 'description' => 'Daily lifestyle tips and trends', 'created_by' => 'system']
]);

// database/seeders/UserSeeder.php
DB::table('users')->insert([
    ['username' => 'admin', 'password_hash' => bcrypt('password'), 'email' => 'admin@example.com', 'role' => 'admin', 'created_by' => 'system']
]);

// database/seeders/CompanyProfileSeeder.php
DB::table('company_profile')->insert([
    ['company_name' => 'My Blog Company', 'email' => 'info@myblog.com', 'address' => '123 Main Street, City', 'phone' => '+123456789', 'linkedin' => 'https://linkedin.com/myblog', 'whatsapp' => '+123456789', 'facebook' => 'https://facebook.com/myblog', 'youtube' => 'https://youtube.com/myblog', 'created_by' => 'system']
]);