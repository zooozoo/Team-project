![screen](/gif/splash.gif) ![screen](/gif/Main.gif) ![screen](/gif/SignUp.gif)


* 프로젝트명 : Explog
* 기간 : 2017.11.27 – 2018.01.12
* 역할 : 배포 / User authentication / Push notification
* 내용 : 자신만의 여행을 기록하고 기록한 사진과 글을 다른 사람과 함께 공유하는 여행기SNS 애플리케이션 입니다. 아무 사진을 올리는 것 보다 자신의 이야기가 담긴 사진과 내용을 여러사람들과 공유할 수 있는 SNS를 만들고자 했습니다. 여행은 자신의 이야기를 가장 잘 담아낼 수 있다고 생각했고, 자신의 여행기를 담아 주변사람과 공유하고 다른 사람의 여행기를 참고할 수 있으면 좋겠다는 생각에 만들게 된 애플리케이션 입니다.
* 사용기술 :
  * django, nginx, uwsgi, supervisor를 활용해 서버를 구축했습니다.
  * 안드로이드, IOS기기와 데이터를 주고받기 위해서 Django Restframework 를 사용해 rest API 를 구현했습니다.
  * Postgresql 을 이용해 모델을 구축했습니다. Django AbstractUser 모델을 활용해 User 모델을 구현했고,
  post 모델과의 m2m 관게를 활용해서 ‘ 좋아요 ’ 기능과 ‘ 팔로우 ’ 기능을 만들었습니다. 배포과정에서는
  AWS RDS 를 사용하여 데이터베이스를 구축했습니다.
  * Django-push-notifications 를 활용하여 push 알람 기능을 구축했습니다.
  * AWS Elasticbeanstalk 와 Docker 를 활용하여 배포했습니다.

* Github - [https://github.com/zooozoo/Team-project](https://github.com/zooozoo/Team-project)
* API(git book) - [https://gangbok119.gitbooks.io/explog-api/content/](https://gangbok119.gitbooks.io/explog-api/content/)
* 작동 동영상 - [https://www.youtube.com/watch?v=n_dV5jrGEx4&t=31s](https://www.youtube.com/watch?v=n_dV5jrGEx4&t=31s)
* 진행사항 기록 - [https://zooozoo.github.io/records/2018-03-23-PROJECT-EXPLOG/](https://zooozoo.github.io/records/2018-03-23-PROJECT-EXPLOG/)
