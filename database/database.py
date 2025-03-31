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
        
    def get_chapters_by_module(self, module_name):
        query = """
        SELECT chapters.id, chapters.chapter_number, chapters.title 
        FROM chapters 
        JOIN modules ON chapters.module_id = modules.id 
        WHERE modules.name = %s
        ORDER BY chapters.chapter_number;
        """
        return self.db.fetch_all(query, (module_name,))

    def get_content_by_chapter(self, chapter_id):
        query = """
        SELECT content_type, content_text 
        FROM content 
        WHERE chapter_id = %s 
        ORDER BY display_order;
        """
        return self.db.fetch_all(query, (chapter_id,))

    def get_questions_by_chapter(self, chapter_id):
        """Fetches all questions for a given chapter ID."""
        query = """
        SELECT id, question_text, option_a, option_b, option_c, correct_option, explanation
        FROM questions
        WHERE chapter_id = %s
        """
        self.db.cursor.execute(query, (chapter_id,))
        questions = self.db.cursor.fetchall()

        print("Debug - Raw Questions:", questions)  # Check data format

        if not questions:
            print(f"No questions found for chapter {chapter_id}")
            return []

        # If results are dictionaries, return them directly
        if isinstance(questions[0], dict):
            return questions
        
        # Otherwise, convert tuples to dictionaries
        return [
            {
                "id": q[0],
                "question_text": q[1],
                "option_a": q[2],
                "option_b": q[3],
                "option_c": q[4],
                "correct_option": q[5],
                "explanation": q[6],
            }
            for q in questions
        ]



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
                password="password", # replace with ur password
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

    def fetch_all(self, query, params=None):
        cursor = self.connection.cursor(dictionary=True)  # Ensure results are buffered
        try:
            cursor.execute(query, params)
            result = cursor.fetchall()
            return result
        finally:
            cursor.close() 
