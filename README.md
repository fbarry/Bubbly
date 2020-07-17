Original App Design Project
===

# Bubbly Water Tracker

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Bubbly Water Tracker is a water intake tracking assistant that not only allows the user to track water intake, but also provides recommended intake and recipe ideas for motivation.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Health & Fitness
- **Mobile:** User can use the camera to customize the background of their home screen and create a profile image. User can share when they meet a water goal. Optional: User can access weather for their location.
- **Story:** For people who want to increase or improve water intake, a tracking app is very helpful. Moreover, for those who do not like the taste of water, ideas for water recipes alongside this app with the ability to save them for later is a great convenience!
- **Market:** The audience is intended for anyone who wants to track water intake for people who: are currently active, struggle with dehydration, want to improve general well-being, have medical conditions, etc.
- **Habit:** Water intake is daily, so the intended use for the app is daily. Users primarily consume information from the app.
- **Scope:** The required elements of the app are engaging, but the optional features will provide a challenge. The idea is thoroughly thought of with a lot of room for expansion.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

Users can:
* Login to a profile
* Enter and edit information about their health to receive a water recommendation
* View their profile using tab bar navigation
* Browse recipes
* Save water recipes
* View saved recipes
* Set customized profile and background pictures using their phone camera
* Access a home screen where they can view a graphic alongside information about recommended and current water intake
* Search for recipes based on ingredients
* A compiled recipe list for saved recipes
* Access to water consumption over time in a graphic
* Create and publish recipes
* Share when a water intake goal is met

**Optional Nice-to-have Stories**

* A schedule for water intake
* Opt-in/out notifications/reminders for water intake at time intervals
* A tab bar option to view weather for their location and recommend more water intake when necessary
* View profile through side bar navigation to accommodate for all of the tab bar navigation
* HealthKit Integration

### 2. Screen Archetypes

* Welcome Screen
   * Sign up or Login
* Sign Up Screen
   * Create a profile
* Login Screen
   * Login to a profile
* Home Screen
   * View a graphic alongside information about recommended and current water intake
   * OPTIONAL: View a schedule for recommended water intake
   * OPTIONAL: Show pop-up of severe heat
   * Share feature
* Water recipe browse / search screen
    * Save water recipes
    * Search for recipes based on ingredients
    * Browse recipes
* Details Screen
    * View water recipe details
* Profile Screen
    * Set customized profile and background pictures using their phone camera
    * View saved recipes
    * View a compiled grocery list for saved recipes
    * Access water consumption over time
* Settings Screen
    * Enter and edit information about their health to receive a water recommendation
    * OPTIONAL: Opt-in/out of notifications/reminders
* OPTIONAL: Weather Screen
    * OPTIONAL: User connects location to view weather and receive notifications when severe heat calls for increased water consumption

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Screen
* Water Recipe Search/Browse
* Profile (Might need to be weather and profile is placed in a side bar)

**Flow Navigation** (Screen to Screen)

* Water Recipe Browse/Search
   * Detail of water recipe and ingredients
* Profile Screen
   * Details Screen
   * Settings Screen

## Wireframes
![Image of wireframe](https://github.com/fbarry/Bubbly/blob/master/Bubbly-Wireframe.jpg)

### [BONUS] Digital Wireframes & Mockups
https://www.figma.com/file/7KhIRv2UjLg3eeKU3illfi/Bubbly?node-id=0%3A1

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]

### Models

#### User

| Property            | Type              | Description                 |
| ------------------- | ----------------- | --------------------------- |
| createdAt (default) | Date              | Creation time of user       |
| id (default)        | String            | Unique id                   |
| name                | String            | Name of user                |
| username            | String            | Username of user's account  |
| password            | String            | Password of user's account  |
| email               | String            | Email (must be unique)      |
| profilePicture      | File              | Set by user                 |
| bio                 | String            | Description set by user     |
| weightIb            | Number            | Weight (in pounds) of user  |
| exercise            | Number            | Minutes of exercise         |

#### Recipe

| Property            | Type              | Description                 |
| ------------------- | ----------------- | --------------------------- |
| createdAt (default) | Date              | Creation time of user       |
| id (default)        | String            | Unique id                   |
| name                | String            | Name of recipe              |
| ingedients          | Array             | Ingredients of recipe       |
| picture             | File              | Picture of recipe           |
| url                 | String            | Link to recipe              |
| descriptionText     | String            | Description of recipe       |
| savedBy             | Relation          | Users who saved             |
| creator             | Pointer to object | User who created            |

#### IntakeLog

| Property            | Type              | Description                 |
| ------------------- | ----------------- | --------------------------- |
| createdAt (default) | Date              | Creation time of user       |
| id (default)        | String            | Unique id                   |
| user                | Pointer to Object | User for log data           |
| goal                | Number            | Target intake of water (oz) |
| achieved            | Number            | Acheived intake (oz)        |

#### STRETCH

#### User

| Property            | Type              | Description                 |
| ------------------- | ----------------- | --------------------------- |
| createdAt (default) | Date              | Creation time of user       |
| id (default)        | String            | Unique id                   |
| account             | Pointer to object | User's account info         |
| profile             | Pointer to object | User's profile info         |
| healthSettings      | Pointer to object | User's health info          |
| settings (stretch)  | Pointer to object | Current account settings    |

#### Account

| Property            | Type              | Description                 |
| ------------------- | ----------------- | --------------------------- |
| createdAt (default) | Date              | Creation time of user       |
| id (default)        | String            | Unique id                   |
| username            | String            | Username of user's account  |
| password            | String            | Password of user's account  |
| email               | String            | Email (must be unique)      |

#### Profile

| Property            | Type              | Description                 |
| ------------------- | ----------------- | --------------------------- |
| createdAt (default) | Date              | Creation time of user       |
| id (default)        | String            | Unique id                   |
| name                | String            | Name of user                |
| profilePicture      | File              | Set by user                 |
| bio                 | String            | Description set by user     |

#### HealthSettings

| Property            | Type              | Description                 |
| ------------------- | ----------------- | --------------------------- |
| createdAt (default) | Date              | Creation time of user       |
| id (default)        | String            | Unique id                   |
| weightIb            | Number            | Weight (in pounds) of user  |
| exercise            | Number            | Minutes of exercise         |

#### Settings

| Property            | Type              | Description                 |
| ------------------- | ----------------- | --------------------------- |
| createdAt (default) | Date              | Creation time of user       |
| id (default)        | String            | Unique id                   |
| backgroundPicture   | File              | User chosen background      |
| logAmounts          | Array             | User chosen log amounts     |
| accentColor         | Pointer to Object | Values of color             |
| customarySystem     | Boolean           | Is user using customary?    |

#### Color

| Property            | Type              | Description                 |
| ------------------- | ----------------- | --------------------------- |
| createdAt (default) | Date              | Creation time of user       |
| id (default)        | String            | Unique id                   |
| red                 | Number            | Float of red component      |
| green               | Number            | Float of red component      |
| blue                | Number            | Float of red component      |

### Networking

#### List of Network Requests by Screen

- Login
    - (Read) Request: username, password
             Response: succeeded, error
- Sign Up
    - (Create) Request: (required input) name, username, password, email, weight, exercise (optional input) profilePcture, bio, settings
               Response: secceeded, error
    
        ```
        User *user = [User new];
        
        user.name = nameField;
        user.username = usernameField;
        user.password = passwordField;
        user.email = emailField;
        user.profilePicture = [Utility fileObjectFromImage:profilePicture];
        user.bio = bioField;
        user.weight = weightField;
        user.exercise = exerciseField;
        user.settings.background = [Utility fileObjectFromImage:backgroundPicture];
        user.settings.logAmounts = @[@1,@2,@4,@8];
        user.settings.accentColor = colors[hightlighted_index]; // Something like this
        user.settings.customarySystem = [segmentedControl indexAt:0].isSelected]; // Something like this, I'm not sure
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                // Utility alert controller to print error with OK
            } else {
                // Take to home screen
            }
        }];
        ```
        
- Home
    - (Read) [User currentUser]
    - (Update) Request: Log
               Response: succeeded, error
    - (Create) Request: (required info) recipeName, recipeIngredients, recipePicture, creatorId (optional info) link, description
               Response: succeeded, error
- Browse
    - (Read) Request: Next 20 recipes
             Response: data, error
- Details
    - (Read) [User currentUser]
    - (Update) Request: Add savedBy User
               Response: succeeded, error
    - (Delete) Request: Delete savedBy User
               Reponse: succeeded, error
- Profile
    - (Read) [User currentUser]
- Settings
    - (Update) Request: currentUser.settings edit
               Response: succeeded, error
    - (Delete) Request: Delete currentUser
               Response: succeeded, error

#### Code Snippets

- Create

    ``` 
    Object *new = [Object new];
    // Set all the properties with (new.property = update;)
    
    [new saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            // Utility alert controller to print error with OK
        } else {
            // Proceed
        }
    }];
    ```
    
- Read

    ``` 
    PFQuery *query = [PFQuery queryWithClassName:@"CLASS"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // Utility alert controller to print error with OK
        } else {
            // Do stuff with the objects
        }
    }]; 
    ```

- Update

    ``` 
    Object.property = update;
    [Object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            // Utility alert controller to print error with OK
        } else {
            // Success alert controller
        }
    }];
    ```

- Delete

    ``` 
    [Object deleteAllInBackground:array block:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            // Utility alert controller to print error with OK
        } else {
            // Procced
        }
    }];
    ```
