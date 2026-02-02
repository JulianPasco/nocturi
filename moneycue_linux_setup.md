# MoneyCue - Local Development Setup Guide

Complete installation guide for setting up MoneyCue Laravel project on Pop!_OS/Ubuntu Linux.

## System Requirements

- PHP 8.2+
- MySQL 8.0+
- Composer
- Node.js 18+ & NPM
- Apache2 (optional, for production-like setup)

---

## Step 1: Update System

```bash
sudo apt update
```

---

## Step 2: Add PHP Repository

Pop!_OS doesn't include PHP 8.2 by default, so add the Ondřej Surý PPA:

```bash
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
```

---

## Step 3: Install PHP 8.2 and Extensions

Install PHP 8.2 with all required extensions:

```bash
sudo apt install php8.2 php8.2-cli php8.2-mysql php8.2-curl php8.2-gd php8.2-zip php8.2-mbstring php8.2-xml php8.2-bcmath php8.2-intl libapache2-mod-php8.2
```

**Note:** `php8.2-json`, `php8.2-tokenizer`, `php8.2-ctype`, and `php8.2-dom` are built into PHP 8.2 core.

Verify PHP installation:

```bash
php -v
# Should show: PHP 8.2.x

php -m | grep -E "(mysql|curl|gd|zip|mbstring|xml|bcmath|json|tokenizer|ctype|dom|intl)"
# Should list all required extensions
```

---

## Step 4: Install MySQL Server

```bash
sudo apt install mysql-server
```

Secure MySQL installation (optional but recommended):

```bash
sudo mysql_secure_installation
```

---

## Step 5: Install phpMyAdmin (Optional)

For easy database management:

```bash
sudo apt install phpmyadmin
```

During installation:
- Select **apache2** when prompted
- Configure database with dbconfig-common: **Yes**
- Set phpMyAdmin password

Access at: `http://localhost/phpmyadmin`

---

## Step 6: Install Composer

```bash
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# Verify
composer --version
```

---

## Step 7: Install Node.js and NPM

```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs

# Verify
node -v
npm -v
```

---

## Step 8: Clone the Project

```bash
git clone https://<username>@bitbucket.org/JRKPasco/moneycue.git
cd moneycue
```

---

## Step 9: Create Database

Login to MySQL as root:

```bash
sudo mysql -u root -p
```

Create database and user:

```sql
CREATE DATABASE moneycue;
CREATE USER 'moneycue'@'localhost' IDENTIFIED BY 'password123';
GRANT ALL PRIVILEGES ON moneycue.* TO 'moneycue'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

Test the connection:

```bash
mysql -u moneycue -p
# Enter password: password123
# Type: SHOW DATABASES;
# Type: EXIT;
```

---

## Step 10: Install Project Dependencies

Install PHP dependencies:

```bash
composer install
```

Install Node.js dependencies:

```bash
npm install
```

---

## Step 11: Configure Environment

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` file:

```bash
nano .env
```

Update database credentials:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=moneycue
DB_USERNAME=moneycue
DB_PASSWORD=password123
```

Generate application key:

```bash
php artisan key:generate
```

---

## Step 12: Run Database Migrations and Seeders

Run migrations and seed the database:

```bash
php artisan migrate:fresh --seed
php artisan db:seed --class=AdminSeeder
```

---

## Step 13: Build Frontend Assets

Compile frontend assets:

```bash
npm run dev
```

For production:

```bash
npm run production
```

---

## Step 14: Set Permissions (Important)

Set proper permissions for storage and cache:

```bash
sudo chown -R www-data:www-data storage bootstrap/cache
sudo chmod -R 775 storage bootstrap/cache
```

Or for development (less secure but easier):

```bash
chmod -R 777 storage bootstrap/cache
```

---

## Step 15: Start Development Server

Start Laravel development server:

```bash
php artisan serve
```

Access the application at: **http://localhost:8000**

### Default Login Credentials

- **Username:** `admin`
- **Password:** `supersecret`

---

## Optional: Apache Configuration

For a production-like setup with Apache:

### Enable Apache Modules

```bash
sudo a2enmod rewrite
sudo a2enmod php8.2
sudo systemctl restart apache2
```

### Create Virtual Host

Create Apache configuration:

```bash
sudo nano /etc/apache2/sites-available/moneycue.conf
```

Add configuration:

```apache
<VirtualHost *:80>
    ServerName moneycue.local
    DocumentRoot /path/to/moneycue/public
    
    <Directory /path/to/moneycue>
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/moneycue-error.log
    CustomLog ${APACHE_LOG_DIR}/moneycue-access.log combined
</VirtualHost>
```

Enable site and restart Apache:

```bash
sudo a2ensite moneycue.conf
sudo systemctl restart apache2
```

Add to `/etc/hosts`:

```bash
sudo nano /etc/hosts
```

Add line:

```
127.0.0.1 moneycue.local
```

Access at: **http://moneycue.local**

---

## Troubleshooting

### PHP Version Issues

If you have multiple PHP versions:

```bash
# Set PHP 8.2 as default
sudo update-alternatives --install /usr/bin/php php /usr/bin/php8.2 82
sudo update-alternatives --set php /usr/bin/php8.2

# Switch Apache to PHP 8.2
sudo a2dismod php8.4
sudo a2enmod php8.2
sudo systemctl restart apache2
```

### Database Connection Issues

Test database connection:

```bash
php artisan tinker
# In tinker: DB::connection()->getPdo()
# Should return PDO object without errors
```

### Permission Issues

```bash
# Reset permissions
sudo chown -R $USER:www-data storage bootstrap/cache
sudo chmod -R 775 storage bootstrap/cache
```

### Clear Laravel Cache

```bash
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear
```

---

## Quick Reference Commands

```bash
# Start development server
php artisan serve

# Watch and compile assets
npm run watch

# Run migrations
php artisan migrate

# Seed database
php artisan db:seed

# Fresh install (drops all tables)
php artisan migrate:fresh --seed

# Clear all cache
php artisan optimize:clear
```

---

## Notes

- Change `password123` to a secure password in production
- Never commit `.env` file to version control
- Run `npm run production` before deploying to production
- Keep PHP and dependencies updated regularly
- Back up database before running `migrate:fresh`

---

## Support

For issues, refer to:
- Laravel Documentation: https://laravel.com/docs/9.x
- Project README: `readme.md`