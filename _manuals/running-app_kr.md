
이 메뉴얼은 macOS 환경 + Flutter와 Android studio가 설치되었다는 전제 하에 Will-be App을 실행 시키는 방법을 기술한다.

### 1. Firebase 설치 및 연동

[파이어베이스 공식문서](https://firebase.google.com/docs/cli?hl=ko#install-cli-mac-linux)의 과정을 풀어씀.

과정
1. 터미널에 아래의 명령어 입력
	```bash
	sudo npm install -g firebase-tools
	```

2. 터미널에 입력해 파이어베이스 로그인, **Will-be계정으로 로그인 해야함.**
	```bash
	firebase login
	```

3. 터미널에 입력해 파이어베이스에 Will-be 프로젝트가 존재하는지 확인 (이미 생성되어있기에 존재해야함)
	```bash
	firebase projects:list
	```

4. Flutter 앱의 디렉터리 내(24SolChl_Will-Be/FlutterApp/WillBeApp)에서 아래의 명령어로 FlutterFire 설치
	```bash
	dart pub global activate flutterfire_cli
 	export PATH="$PATH":"$HOME/.pub-cache/bin"  # flutterfire 명령 사용 가능하게
	```

5. 아래의 명령어로 app을 firebase에 연결. -> 선택할 때 android, ios 빼고 선택 풀기
	```bash
	flutterfire configure
	```
	**Before**
	![image](https://github.com/GDSC-DJU/24SolChl_Will-Be/assets/33396317/5ff98caf-0537-4a9d-b796-678a440c0236)
	**After**
	![image](https://github.com/GDSC-DJU/24SolChl_Will-Be/assets/33396317/fedbdb53-b55d-4728-be9e-dd41302e1fd7)


### 2. Firebase SHA키 설정

1. 터미널에 아래의 명령어 입력
	```bash
	 keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
	```
	- 만약 오류가 발생한다면 플러터 앱 빌드를 한 번 이상 한다.
2. SHA-1 키를 복사 (기본 설정으로는 SHA256 키는 앱 실행히 인증 오류가 발생한다).
4. 파이어베이스 웹사이트에 접속해 Will-be 계정으로 로그인한다.
5. Will-be 프로젝트를 눌러 콘솔화면으로 들어간다.
6. 왼쪽상단 "프로젝트 개요" 오른쪽의 톱니바퀴에서 "프로젝트 설정"을 클릭
7. "일반"탭의 최 하단에 "디지털 지문 추가"를 클릭해 복사한 SHA-1 또는 SHA-256키를 등록한다.
8. 끝.


위의 모든 과정을 완료했다면 (API_keys.dart 파일 작성 포함) 앱 빌드 후 회원가입 및 로그인, 자동로그인 기능이 동작함.
