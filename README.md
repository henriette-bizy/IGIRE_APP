# IGIRE - Financial & Business Training CLI Application

## 📌 Overview
**IGIRE** is a command-line Python application designed to support women entrepreneurs by providing interactive financial literacy and business training. The program includes structured learning modules, interactive exercises, progress tracking, a business plan generator, and networking recommendations.

---

## ✨ Features
### 1️⃣ **User Authentication**
✅ New users can register by providing their name, age, business interest, and email.  
✅ Returning users can log in using their username or email.  
✅ Passwords are securely stored using hashing techniques.

### 2️⃣ **Main Menu & Navigation**
Upon logging in, users can access:
- 📖 **Financial Literacy**
- 💰 **Budgeting & Savings**
- 📊 **Business Planning & Management**
- 💵 **Accessing Funding & Loans**
- 🎯 **Marketing & Branding**
- 📝 **Business Plan Generator**
- 🌍 **Community & Networking Suggestions**
- 🚪 **Exit the Program**

### 3️⃣ **Training Modules (Interactive Learning)**
📌 Informational content (text-based lessons, definitions, examples)  
🎯 Interactive exercises (quizzes, scenario-based decision-making)  
🛠️ Practical tasks (e.g., "Create a budget" or "Identify funding sources")  
📊 Personalized feedback at the end of each module

### 4️⃣ **Progress Tracking**
📌 Stores completed modules and tracks user progress  
📌 Allows users to return to unfinished modules

### 5️⃣ **Business Plan Generator**
📌 Users input details about their business idea  
📌 Generates a structured business plan template

### 6️⃣ **Community & Networking Suggestions**
📌 Provides recommendations for online or local networking groups  
📌 Suggests funding opportunities and mentorship programs based on business interests

---

## 🛠 Tech Stack
- **Programming Language:** Python 🐍
- **Database:** MySQL 8 🗄️
- **CLI Interface:** Built using Python’s standard libraries 💻
- **Security:** Password hashing for authentication 🔒

---

## ⚙ Installation & Setup
### 🔹 Prerequisites
Ensure you have the following installed:
- Python 3.8+
- MySQL 8+
- Required Python libraries (install via `pip`):
  ```sh
  pip install mysql-connector-python bcrypt
  ```

### 🔹 Database Setup
1️⃣ Create a new MySQL database:
   ```sql
   CREATE DATABASE igire;
   ```
2️⃣ Create necessary tables (users, modules, quizzes, progress, business_plans, etc.).
3️⃣ Update `config.py` with database connection details.

### 🔹 Running the Application
1️⃣ Clone the repository:
   ```sh
   git clone https://github.com/yourusername/igire.git
   ```
2️⃣ Navigate to the project folder:
   ```sh
   cd igire
   ```
3️⃣ Run the application:
   ```sh
   python main.py
   ```

---

## 🚀 Future Enhancements
- 🤖 Advanced AI-based business recommendations
- 📈 More dynamic and personalized training content
- 🌐 Integration with external funding and mentorship platforms

---

## 📜 License
This project is open-source and available under the **MIT License**.
---

## 👥 Contributors
- Henriette Biziyaremye 👩‍💻
- Aderline Gashugi 👨‍💻
- Ntagungira Ali Rashid 👨‍💻
- Shumbusho Anglebert 👨‍💻
- Aderline Gashugi 👨‍💻
- Christian Ingabire Habimana 👨‍💻
- Davy Dushimiyimana 👨‍💻

