# EXPLOG
--- 


## * Main Page(시작 페이지) 

## [* EXPLOG 소개 YouTube 영상 링크 입니다.](https://youtu.be/Vf85uJOZKoU) <br>

자신의 여행을 기록하고, 공유하는 여행기 공유 SNS 입니다. <br>


| Splash | Main |
| :--: | :--: |  
| ![screen](/gif/splash.gif)| ![screen](/gif/Main.gif)|  <br> 


| * | * | * | 
| :--: | :--: | :--: |
| ![screen](/img/Main.png)| ![screen](/img/Main-1.png)| ![screen](/img/Main-1.png)|  <br>

---

## * Post 작성 페이지 

| Post를 작성 페이지 | Post 를 볼때  |
| :--: | :--: |  
| ![screen](/gif/Post.gif)| ![screen](/gif/Post_intro.gif)|  <br> 

| Post 표지 타이틀 | 날짜 | 작성될 대륙 | 
| :--: | :--: | :--: |
| ![screen](/img/Post-1-1.png)| ![screen](/img/Post-1-2.png)| ![screen](/img/Post-1-3.png)|  <br>

| 이미지 추가 | 일반 글 추가 | 강조글 추가 | 
| :--: | :--: | :--: |
| ![screen](/img/Post-2-1.png)| ![screen](/img/Post-2-2.png)| ![screen](/img/Post-2-3.png)|  <br>

| 유저가 포스트를 읽을때 | * | * | 
| :--: | :--: | :--: |
| ![screen](/img/Post-3-1.png)| ![screen](/img/Post-3-2.png)| ![screen](/img/Post-3-3.png)|  <br>

---

## * Post 의 댓글 페이지 

| 댓글 작성 페이지 | 좋아요 버튼 | PushNotification |
| :--: | :--: |  :--: |
| ![screen](/gif/Reply.gif)| ![screen](/gif/Like.gif)| ![screen](/img/PushNotification-1.jpg) | <br> 

| 댓글 페이지 | 좋아요버튼 적용 | 좋아요 버튼 | 
| :--: | :--: | :--: |
| ![screen](/img/Reply.png)| ![screen](/img/Like.png)| ![screen](/img/Like-1.png)|  <br>

---

## * Search 기능 

| 검색 | 
| :--: | 
| ![screen](/gif/Search.gif)|  <br> 

| 검색 전 | 파리 | 여행 | 
| :--: | :--: | :--: |
| ![screen](/img/Search.png)| ![screen](/img/Search-1.png)| ![screen](/img/Search-2.png)|  <br>

---

## * Login & Sign Up

| SignUp | Login |
| :--: | :--: |  
| ![screen](/gif/SignUp.gif)| ![screen](/gif/Login.gif)|  <br> 

| SignUp | Login | Login | 
| :--: | :--: | :--: |
| ![screen](/img/SignUp.png)| ![screen](/img/Login.png)| ![screen](/img/Login-1.png)|  <br>

---

## * UserProfile 


| UserProfile | 
| :--: | 
| ![screen](/gif/UserProfile.gif)|  <br> 

| UserProfile Post List | UserProfile | 
| :--: | :--: | 
| ![screen](/img/UserProfile.png)| ![screen](/img/UserProfile-1.png)|  <br>

---

## * Following, Follower & Delete Post 

| Following & Follower |  Delete Post | Modify PostCover & Post Contents |
| :--: | :--: | :--: |
| ![screen](/gif/UserProfile_Following.gif) | ![screen](/gif/UserProfile_DeletePost.gif) | ![screen](/img/ModifiedPost.jpg) |<br>

--- 

## * Modify UserProfile Information 

| 닉네임 변경 | 프로필 이미지 변경 | 비밀번호 변경 | 
| :--: | :--: | :--: |
| ![screen](/gif/UserProfile_Modified_nickName.gif)| ![screen](/gif/UserProfile_Modified_ProfiledImage.gif)| ![screen](/gif/UserProfile_Modified_Password.gif)|  <br>

----

## * Push Notification

| Push Notification | badgeNumber | badgeNumber | 
| :--: | :--: | :--: |
| ![screen](/img/PushNotification.png)| ![screen](/img/PushNotification-1-2.PNG)| ![screen](/img/PushNotification-1-3.jpg)|  <br>

---

## * Benchmarking Application

| kakao Place | volo |
| :--: | :--: |
| ![screen](/gif/kakaoPlace.gif)| ![screen](/gif/volo.gif) | <br>

- KakaoPlace 의 Main UI
	- [KakaoPlace](https://www.kakaocorp.com/service/KakaoPlace)
- Volo의 Post 작성 부분
	- [Volo](https://withvolo.com/?lang=ko)


## Server: Python-django

#### * [API Documents](https://gangbok119.gitbooks.io/explog-api/content/) <br> 

- dataModel <br>

![screen](/img/EXPLOG_DataModel.jpg)

1. User : 유저 한명이 가지고 있는 정보 입니다.
	- PK(Private Key) : 고유한 식별키 입니다. 해당 키를 가지고, 어떤 유저인지 판별하는데 사용됩니다
	- Token
	- Email
	- img_profile : User 의 프로필 이미지 입니다
	- liked_posts: 유저가 좋아요를 누른 Post의 목록입니다
	- Following/Follower: 유저와 Follow 관계를 맺고 있는 유저들의 목록입니다
	
2. Post : 유저가 작성한 Post 입니다
	- Pk(Private Key): Post 의 고유한 값 입니다.
	- Contents: Post 속에 있는, Text, Photo, Path 값들을 묶고 영역 입니다
		- Text : Post에 묶여 있는 Text는 type(일반 글과, 강조글), Prvate Key 를 가지고 있습니다.
		- Photo 
		- Path 
	- Reply: Post 에 댓글을 작성하게 되면 엮이게 되고, Reply 과 Post 의 Private Key 는 서로 독립적으로 고유합니다.
	- Title
	- img : 표지 이미지 입니다
	- Start_Date
	- End_Date
	- Continent

---

## 함께 하신분들 

- Android 

- Server(Python-django)
	- :octocat: [gangbok119](https://www.gitbook.com/@gangbok119) <br>
	- :octocat: [zooozoo](https://www.gitbook.com/@zooozoo)

---

## Your input is welcome!

어떤 내용이라도, 피드백은 언제나 환영입니다! <br>
<dev.mjun@gmail.com>

---

## Referece 

1. [Alamofire](https://github.com/Alamofire/Alamofire)
2. [Alamofire Image](https://github.com/Alamofire/AlamofireImage)
3. [ParallaxHeader](https://github.com/devminjun/ParallaxHeader)
4. [TableView, CollectionView 세팅](https://ashfurrow.com/blog/putting-a-uicollectionview-in-a-uitableviewcell-in-swift/)
5. [dealing with complex tableViews](https://medium.cobeisfresh.com/dealing-with-complex-table-views-in-ios-and-keeping-your-sanity-ff5fee1fbb83)
























