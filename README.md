# GiveAway
A new Flutter mobile application for a hackathon

## Introduction
This project is my first attempt at building a full-fledged mobile application using Flutter and Firebase. It is an app for users in a community to buy, sell or donate old items, rather than them going to waste. This can act towards environment sustainability and building a sense of community, as well as reducing carbon footprint.

## User Stories
### Required
- [x] User can register a new account
- [x] User can login to his account
- [x] User can view items in feed
- [x] User can post a new item
- [x] User can upload an image for his item
    - [x] User can upload image from photo gallery
    - [x] User can upload image using camera 
- [ ] User can edit his posted item
- [ ] User can delete his posted item
- [x] User can tap on item to view additional details

### Additional
- [ ] User can filter his feed by item type and distance
- [ ] User can find donation centers near him on map
- [ ] User can message or call the owner
- [ ] User gets notifications

## Data Model in Firebase
### Users
#### Uses FirebaseAuth
- email: String
- password: String

### Items
#### Uses Cloud Firestore
- name: String
- description: String (optional)
- category: String
- contact: String phone number
- imageUrl: String file path
- author: String *User* email
- available: boolean
- location: geolocation
- createdAt: datetime
