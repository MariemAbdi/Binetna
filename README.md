# MAE-Staff-Application-
This is my end-of-study project for obtaining a Bachelor's degree in Business Information Systems.

It's a mobile application developed using Flutter, Dart, and Firebase for the insurance company "La Mutuelle Assurance de l'Enseignmement (A.K.A la M.A.E), Tunisia".

There are 3 admins who can access a specific functionality in addition to what all the users can do:

1. The Account Activation Manager can either approve or deny an account's activation request for the user to access their account. Once approved, an e-mail is sent to that user. They can also view the information of all the approved users (not the passwords for sure).

2. The Post Manager has the ability to add new articles* (title, description, category, and photo) and then edit or delete them.

*An article is a post to share both internal and external information among the team. Its category can be: celebrations, events, news, or other.

3. The Medical Leave Manager can view the list of medical leave requests* and has the ability to accept or deny them.

They see some information about the requester (name, phone number, and department) as well as the request's data.

In the case of a denial, the manager is required to enter a denial reason, which will be displayed to the user later.

*Medical leave requests have a starting and an ending date, a reason, and a certificate picture (which is zoomable and downloadble).



These three managers/admins are all users as well. Every user has some functionalities they can do:

* Signup/Login

* Chat: look for users to initiate one-on-one conversations (sending text/images).

* Request medical leave: review their list of requests (red: denied; yellow: unstudied; green: approved); edit (if unstudied); delete

*Carpooling: view, join, offer, wait for approval.

* Manage profile: edit information (when it comes to email and password, they're required to re-type the current password), edit profile picture (Take picture, Choose from files, Remove picture) => a default avatar is displayed instead depending on the gender).

* Posts: Read articles, like or dislike them, search (using a keyword), filter (by title and date, category, or creation date), and so on.

"Reset password"

* Set the app's theme: light or dark

* Set the app's language: French or English

* Turn on/off receiving notifications

Here are some screenshots of the application.


![onboarding](https://user-images.githubusercontent.com/100727442/176708916-55df3c96-b113-41b3-9ae5-93e03526ddaa.png)

