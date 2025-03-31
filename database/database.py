# database.py
import mysql.connector
from mysql.connector import Error
import hashlib
import re

class User:
    def __init__(self, db):
        self.db = db
        self.logged_in_user = None

    def hash_password(self, password):
        """Hash password using SHA-256"""
        return hashlib.sha256(password.encode()).hexdigest()

    def is_valid_email(self, email):
        """Basic email validation"""
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return re.match(pattern, email) is not None

    def register(self, email, password, name, age=None, business_interest=None):
        """Register a new user with email"""
        if not self.is_valid_email(email):
            return False, "Invalid email format"
        
        cursor = self.db.cursor
        try:
            # Check if email exists
            cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
            if cursor.fetchone():
                return False, "Email already registered"
            
            # Validate password length
            if len(password) < 8:
                return False, "Password must be at least 8 characters"
            
            hashed_password = self.hash_password(password)
            
            # Insert new user
            cursor.execute(
                "INSERT INTO users (email, password, name, age, business_interest) "
                "VALUES (%s, %s, %s, %s, %s)",
                (email, hashed_password, name, age, business_interest)
            )
            self.db.commit()
            return True, "Registration successful"
            
        except Error as e:
            return False, f"Database error: {e}"

    def login(self, email, password):
        """Authenticate user with email and password"""
        if not self.is_valid_email(email):
            return False, "Invalid email format"
        
        cursor = self.db.cursor
        try:
            hashed_password = self.hash_password(password)
            cursor.execute(
                "SELECT * FROM users WHERE email = %s AND password = %s", 
                (email, hashed_password)
            )
            user = cursor.fetchone()
            
            if user:
                self.logged_in_user = email
                return True, "Login successful"
            else:
                return False, "Invalid email or password"
                
        except Error as e:
            return False, f"Database error: {e}"

    def logout(self):
        """Log out current user"""
        if self.logged_in_user:
            self.logged_in_user = None
            return True, "Logged out successfully"
        return False, "No user is logged in"

    def is_logged_in(self):
        """Check if user is logged in"""
        return self.logged_in_user is not None

    def get_current_user(self):
        """Get details of currently logged in user"""
        if not self.logged_in_user:
            return None
        
        cursor = self.db.cursor
        try:
            cursor.execute(
                "SELECT id, email, name, age, business_interest FROM users WHERE email = %s", 
                (self.logged_in_user,)
            )
            return cursor.fetchone()
        except Error as e:
            print(f"Error fetching user data: {e}")
            return None


class Database:
    def __init__(self):
        self.connection = None
        self.cursor = None
        
    def connect(self):
        try:
            print("Attempting database connection...")
            self.connection = mysql.connector.connect(
                host="127.0.0.1",
                user="root",
                password="dearmama", # replace with ur password
                port=3306,
                database="igire",  # Connect directly to our database
                use_pure=True,
                connection_timeout=10
            )
            if self.connection.is_connected():
                print("Connection established successfully")
                self.cursor = self.connection.cursor(dictionary=True)
            else:
                print("Failed to establish connection")
        except Error as e:
            print(f"Error connecting to MySQL: {e}")
            raise

    def fetch_one(self, query, params=None):
        """Execute a query and return one row"""
        try:
            self.cursor.execute(query, params)
            return self.cursor.fetchone()
        except Error as e:
            print(f"Error executing query: {e}")
            return None

    def execute(self, query, params=None):
        """Execute a query and commit changes"""
        try:
            self.cursor.execute(query, params)
            self.connection.commit()
            return True
        except Error as e:
            print(f"Error executing query: {e}")
            return False

    def commit(self):
        if self.connection and self.connection.is_connected():
            self.connection.commit()
        else:
            print("Cannot commit: No active connection")

    def disconnect(self):
        if hasattr(self, 'cursor') and self.cursor:
            self.cursor.close()
        if self.connection and self.connection.is_connected():
            self.connection.close()
            print("MySQL connection closed")