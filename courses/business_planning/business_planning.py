from typing import Dict, List
import json
import os
from database.database import Database
from courses.business_planning.content import TOPIC_CONTENT  # Add this import

class BusinessPlanningModule:
    def __init__(self, db, user_id):
        self.db = db
        self.user_id = user_id
        self.topics = {
            1: "Business Model Canvas",
            2: "Market Analysis",
            3: "Financial Planning",
            4: "Operations Management",
            5: "Risk Assessment"
        }
    
    def display_menu(self):
        print("\n=== Business Planning & Management ===")
        print("\nAvailable Topics:")
        for key, topic in self.topics.items():
            progress = self.get_topic_progress(key)
            status = "✓" if progress.get('completed', False) else " "
            print(f"{key}. [{status}] {topic}")
        print("\n0. Return to Main Menu")
    
    def get_topic_progress(self, topic_id):
        query = """
            SELECT * FROM progress 
            WHERE user_id = %s AND module = 'business_planning' AND topic_id = %s
        """
        result = self.db.fetch_one(query, (self.user_id, topic_id))
        return result if result else {'completed': False, 'score': 0}
    
    def save_progress(self, topic_id, score):
        query = """
            INSERT INTO progress (user_id, module, topic_id, score, completed)
            VALUES (%s, 'business_planning', %s, %s, TRUE)
            ON DUPLICATE KEY UPDATE score = %s, completed = TRUE
        """
        self.db.execute(query, (self.user_id, topic_id, score, score))
    
    def show_topic_content(self, topic_id):
        content = self.load_topic_content(topic_id)
        print(f"\n=== {self.topics[topic_id]} ===")
        print("\nLESSON CONTENT:")
        print(content['description'])
        
        print("\nKEY POINTS:")
        for idx, point in enumerate(content['key_points'], 1):
            print(f"{idx}. {point}")
        
        input("\nPress Enter to continue to the exercise...")
        return self.run_exercise(topic_id, content['exercise'])
    
    def run_exercise(self, topic_id, exercise):
        print("\n=== Practice Exercise ===")
        print(exercise['question'])
        for idx, option in enumerate(exercise['options'], 1):
            print(f"{idx}. {option}")
        
        while True:
            try:
                answer = int(input("\nEnter your answer (1-4): "))
                if 1 <= answer <= 4:
                    break
                print("Please enter a number between 1 and 4")
            except ValueError:
                print("Please enter a valid number")
        
        correct = answer == exercise['correct_answer']
        score = 100 if correct else 0
        
        print("\nResult:", "Correct!" if correct else "Incorrect")
        print(f"Explanation: {exercise['explanation']}")
        
        self.save_progress(topic_id, score)
        return score
    
    def load_topic_content(self, topic_id):
        # In a real application, this would load from a database
        # For now, we'll use hardcoded content
        return TOPIC_CONTENT.get(topic_id, {})

    def run(self):
        while True:
            self.display_menu()
            try:
                choice = int(input("\nEnter your choice (0-5): "))
                if choice == 0:
                    break
                elif choice in self.topics:
                    score = self.show_topic_content(choice)
                    print(f"\nYour score: {score}%")
                    input("\nPress Enter to continue...")
                else:
                    print("Invalid choice. Please try again.")
            except ValueError:
                print("Please enter a valid number.")