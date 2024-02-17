# DiscoveryPage App

Overview:
You are tasked with creating a Flutter app that features a discovery page. This page should load
data from a mock API and implement pagination with unlimited scroll until the API returns empty
data.

Requirements:
1. Discovery Page:
- Implement a Flutter screen that displays cards representing items fetched from a mock
API.
- Each card should display relevant information about the item, such as title, description,
and image if available.
2. API Integration:
- Use the following endpoint to fetch mock data:
https://api-stg.together.buzz/mocks/discovery

- Include query parameters for `page` and `limit` in your API requests to implement
pagination.
E.g.
https://api-stg.together.buzz/mocks/discovery?page=1&limit=10

3. Pagination:
- Implement pagination for loading more items as the user scrolls.
- Load additional items when the user reaches the bottom of the list.
- Stop loading items when the API returns an empty response indicating the end of the
list.
4. UI/UX:
- Design the page to be visually appealing and user-friendly.
- Implement smooth animations and transitions, especially during loading and scrolling.
5. Code Quality:
- Write clean and well-structured code.
- Utilize Flutter best practices and follow the Flutter style guide.
- Ensure code readability with meaningful variable names and comments where
necessary.
6. Error Handling:
- Handle potential errors gracefully, such as network failures or API errors.
- Display appropriate error messages to the user when necessary.
7. Testing:
- Ensure that the app functions correctly under various scenarios, including edge cases.

![image](https://github.com/arju7jha/DiscoveryPage-App/assets/88245601/16f47bd6-001c-4877-9d94-7e3c383a8740)

# Choices made for development :

# Widget Composition:
We chose a composition of widgets that are commonly used in Flutter development for building the UI. This ensures familiarity and ease of understanding for other developers.

# Error Handling Approach:
We opted for a simple error handling approach using try-catch blocks and SnackBar to display error messages. This provides a user-friendly way to communicate errors without disrupting the user experience.

Automatic Refresh on Connection: To enhance user experience, we decided to automatically refresh the data when the internet connection is restored. This ensures that users see up-to-date content without manual intervention.

Connectivity Plugin: We chose the connectivity plugin for monitoring internet connection status due to its simplicity and reliability. It provides an easy way to detect changes in the device's connectivity state.

Code Readability: Throughout the code, we aimed to maintain readability by using descriptive variable names, organizing code into logical functions, and following Flutter's style guide for formatting and conventions.
