# Event Booking App

This is a full-stack event booking application I built. It includes a mobile app for users to browse and book events, and a backend server to manage everything.

## Technologies Used

*   **Frontend (Mobile App):** Flutter
*   **Backend:** Django & Django REST Framework

## Project Structure

The repository is organized into two main parts:

*   `event_booking/`: This directory contains the source code for the Flutter mobile application.
*   `event_booking_backend/`: This directory contains the source code for the Django backend server.

## Getting Started

Here's how you can get the project up and running on your local machine.

### Backend Setup (Django)

1.  Navigate to the `event_booking_backend` directory:
    ```bash
    cd event_booking_backend
    ```
2.  Install the required Python packages:
    ```bash
    pip install -r requirements.txt
    ```
3.  Run the database migrations:
    ```bash
    python manage.py migrate
    ```
4.  Start the development server:
    ```bash
    python manage.py runserver
    ```

The backend API will be available at `http://127.0.0.1:8000/`.

### Frontend Setup (Flutter)

1.  Navigate to the `event_booking` directory:
    ```bash
    cd event_booking
    ```
2.  Get the Flutter dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the app on your desired device or simulator:
    ```bash
    flutter run
    ```
