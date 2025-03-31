# main.py
from database.database import Database, User

def display_welcome():
    print("\n" + "="*50)
    print("Welcome to IGIRE - Empowering Women Entrepreneurs")
    print("="*50)
    print("\nPlease choose an option:")
    print("1. Register")
    print("2. Login")
    print("3. Exit")

def get_user_input(prompt, input_type=str):
    while True:
        try:
            user_input = input(prompt).strip()
            if not user_input:
                print("Input cannot be empty. Please try again.")
                continue
            return input_type(user_input)
        except ValueError:
            print(f"Invalid input. Please enter a valid {input_type.__name__}.")

def registration_flow(user_manager):
    print("\n" + "-"*50)
    print("REGISTRATION")
    print("-"*50)
    
    email = get_user_input("Email: ")
    password = get_user_input("Password: ")
    name = get_user_input("Full Name: ")
    age = get_user_input("Age (optional, press enter to skip): ", int) if input("Would you like to provide your age? (y/n): ").lower() == 'y' else None
    business_interest = get_user_input("Business Interest (optional, press enter to skip): ") if input("Would you like to provide your business interest? (y/n): ").lower() == 'y' else None
    
    success, message = user_manager.register(email, password, name, age, business_interest)
    print(f"\n==> {message}")
    return success

def login_flow(user_manager):
    print("\n" + "-"*50)
    print("LOGIN")
    print("-"*50)
    
    email = get_user_input("Email: ")
    password = get_user_input("Password: ")
    
    success, message = user_manager.login(email, password)
    print(f"\n==> {message}")
    return success

def main_menu(user_manager):
    while True:
        print("\n" + "="*50)
        print("MAIN MENU")
        print("="*50)
        print("\n1. Financial Literacy")
        print("2. Budgeting & Savings")
        print("3. Business Planning & Management")
        print("4. Accessing Funding & Loans")
        print("5. Marketing & Branding")
        print("6. Assess yourself")
        print("7. View Profile")
        print("8. Logout")
        
        choice = get_user_input("\nEnter your choice (1-7): ", int)
        
        if choice == 1:
            print("\nFinancial Literacy module selected")
            # Implement module functionality
        elif choice == 2:
            print("\nBudgeting & Savings module selected")
            # Implement module functionality
        elif choice == 4:
            display_chapters(user_manager, "Accessing Funding & Loans")
        elif choice == 7:
            user = user_manager.get_current_user()
            print("\n" + "-"*50)
            print("YOUR PROFILE")
            print("-"*50)
            print(f"Email: {user['email']}")
            print(f"Name: {user['name']}")
            if user['age']:
                print(f"Age: {user['age']}")
            if user['business_interest']:
                print(f"Business Interest: {user['business_interest']}")
            print("-"*50)
        elif choice == 8:
            user_manager.logout()
            print("You have been logged out.")
            break
        else:
            print("Module coming soon!")
            
def display_chapters(user_manager, module_name):
    print(f"\nFetching chapters for {module_name}...\n")
    chapters = user_manager.get_chapters_by_module(module_name)

    if not chapters:
        print("No chapters found.")
        return
    
    for ch in chapters:
        print(f"{ch['chapter_number']}. {ch['title']}")

    choice = get_user_input("\nEnter the chapter number to read or 0 to go back: ", int)

    if choice == 0:
        return

    selected_chapter = next((ch for ch in chapters if ch["chapter_number"] == choice), None)
    
    if selected_chapter:
        display_chapter_content(user_manager, selected_chapter["id"])
    else:
        print("Invalid choice.")

def display_chapter_content(user_manager, chapter_id):
    print("\nLoading content...\n")
    content = user_manager.get_content_by_chapter(chapter_id)

    if not content:
        print("No content available.")
        return
    
    for item in content:
        print(f"[{item['content_type'].capitalize()}] {item['content_text']}\n")

def main():
    db = Database()
    db.connect()
    user_manager = User(db)
    
    try:
        while True:
            display_welcome()
            choice = get_user_input("\nEnter your choice (1-3): ", int)
            
            if choice == 1:
                if registration_flow(user_manager):
                    # After successful registration, proceed to login
                    if login_flow(user_manager):
                        main_menu(user_manager)
            elif choice == 2:
                if login_flow(user_manager):
                    main_menu(user_manager)
            elif choice == 3:
                print("\nThank you for using IGIRE. Goodbye!")
                break
            else:
                print("Invalid choice. Please enter 1, 2, or 3.")
    finally:
        db.disconnect()

if __name__ == "__main__":  
    main()