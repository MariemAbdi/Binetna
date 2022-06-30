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
![0](https://user-images.githubusercontent.com/100727442/176723057-65cf7d98-e9d3-44d6-9f8c-635e6ada983d.png)
![1](https://user-images.githubusercontent.com/100727442/176723078-dcbca66e-78ee-47b1-9a34-9a98898e1f99.png)
![2](https://user-images.githubusercontent.com/100727442/176723127-5555f526-718d-4f6c-95c7-862ec5c3f92c.png)
![3](https://user-images.githubusercontent.com/100727442/176723147-fecd85de-03f6-4610-8094-be5bb2b1ca14.png)
![4](https://user-images.githubusercontent.com/100727442/176723164-a276b5d4-124a-48bc-91fd-a8a46e7be2b4.png)
![5](https://user-images.githubusercontent.com/100727442/176723189-0b2158e2-62e1-4174-8aba-43b08f7f4edf.png)
![6](https://user-images.githubusercontent.com/100727442/176723240-ab36fbd2-64a8-4bbf-9fc4-85c75085426b.png)
![7](https://user-images.githubusercontent.com/100727442/176723274-c200630a-2d04-4af9-b411-3eafc92a8aa8.png)
![8](https://user-images.githubusercontent.com/100727442/176723347-743d4079-8ded-460d-9d61-eb8ce033d14f.png)
![9](https://user-images.githubusercontent.com/100727442/176723413-ddc09ece-d0e7-4890-a348-428dcfdd54b5.png)
![10](https://user-images.githubusercontent.com/100727442/176723468-fa6b644a-00f5-456c-973b-1fc74d6ae6fc.png)
![11 5](https://user-images.githubusercontent.com/100727442/176722379-628a56a3-bf5e-4c92-9926-5038f9c44fa6.png)
![11](https://user-images.githubusercontent.com/100727442/176722461-d0d3d85f-43eb-4a87-9117-939861fede05.png)
![12](https://user-images.githubusercontent.com/100727442/176722541-9350471e-395f-4b1b-8b44-7a1e0ae80401.png)
![13](https://user-images.githubusercontent.com/100727442/176722558-4ea1caf1-525e-45d6-88a7-033052871641.png)
![14](https://user-images.githubusercontent.com/100727442/176722678-a7a74530-c405-424c-8b53-a8eea8369d6c.png)
![15](https://user-images.githubusercontent.com/100727442/176722714-a3c9d5d5-8fca-42f7-892c-e3db153b62ce.png)
![16](https://user-images.githubusercontent.com/100727442/176722729-558a45af-7c22-4302-a52e-d2036e397e68.png)
![17](https://user-images.githubusercontent.com/100727442/176722770-c565c99b-f37d-4570-b990-9e023855881d.png)
![18 5](https://user-images.githubusercontent.com/100727442/176722787-bd3e1d2f-0108-4493-85c1-34c0bda1a96d.png)
![18](https://user-images.githubusercontent.com/100727442/176722803-4d6fe291-6a3a-41b8-b5c6-273547455fd1.png)
![19](https://user-images.githubusercontent.com/100727442/176722824-e26c56ca-b207-40bf-ad43-f5b7d452c25c.png)
![20](https://user-images.githubusercontent.com/100727442/176722839-1f1d93ea-3d29-4866-9a50-af45bfd63415.png)
![21](https://user-images.githubusercontent.com/100727442/176722850-5cd86b5b-0b83-48f4-a3ed-f0a1482d3ff9.png)
![22](https://user-images.githubusercontent.com/100727442/176722882-d0d59a75-515c-4e58-910d-141b512183a1.png)
![23](https://user-images.githubusercontent.com/100727442/176722926-d9271902-6c5e-4ec6-842e-16bef1e7ebbe.png)
![96](https://user-images.githubusercontent.com/100727442/176722945-93e9d8d7-e566-4ade-97e7-7119e6c6bd51.png)
![97 5](https://user-images.githubusercontent.com/100727442/176722963-0c7c25f1-dd61-4149-8b45-dbda13898cac.png)
![97](https://user-images.githubusercontent.com/100727442/176722986-44e25349-c4fc-4c4d-bee0-7d70a65a31b2.png)
![98](https://user-images.githubusercontent.com/100727442/176723004-b7a6dc3e-fc55-4b2b-ab09-de386b0160c3.png)
![99](https://user-images.githubusercontent.com/100727442/176723023-80f1cfb7-849e-4b9f-8462-6ca3f7f6b6a2.png)
![100](https://user-images.githubusercontent.com/100727442/176723040-c43fb46c-f7d7-4bfe-9dc1-210cc866f95a.png)
