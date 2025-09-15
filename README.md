# 웹&앱 응용 프로젝트

## ⚾ KBO 팬 커뮤니티 (JSX + Servlet)

KBO 리그 팬들을 위한 커뮤니티 웹 애플리케이션입니다. 사용자들은 팀별 게시판에서 자유롭게 소통하고, 경기 소식 및 정보를 공유할 수 있습니다. 프론트엔드는 JSX를 사용하여 동적인 UI를 구현했으며, 백엔드는 Java Servlet으로 RESTful API를 구축하여 견고한 데이터 처리를 담당했습니다.

---

### 🔥 주요 기능 (Features)

-   **팀별 게시판**: 10개 구단별 전용 게시판을 제공하여 각 팀 팬들이 모여 소통
-   **게시글 작성/조회/수정/삭제**: CRUD 기능을 통해 게시글 관리
-   **댓글 기능**: 게시글에 댓글을 작성하고 관리 (추가/삭제)
-   **사용자 인증**: 로그인/회원가입 기능을 통한 사용자 관리 (JWT 또는 세션 기반)
-   **실시간 경기 스코어**: (옵션) 외부 API 연동을 통한 실시간 경기 결과 및 일정 표시
-   **반응형 디자인**: 다양한 디바이스에서 최적화된 사용자 경험 제공

---

### 🛠️ 기술 스택 (Tech Stack)

#### **프론트엔드 (Frontend)**
-   **JSX**: React와 유사한 문법으로 컴포넌트 기반 UI 구축 (순수 React 대신 JSX 사용 시 명시)
-   **JavaScript (ES6+)**: 클라이언트 측 로직 및 동적 UI 제어
-   **HTML5 / CSS3**: 웹 표준 마크업 및 스타일링
-   **Axios**: 비동기 HTTP 통신 라이브러리

#### **백엔드 (Backend)**
-   **Java Servlet**: RESTful API 엔드포인트 구현 및 비즈니스 로직 처리
-   **JDBC**: MySQL 데이터베이스 연동
-   **Tomcat**: 웹 애플리케이션 서버

#### **데이터베이스 (Database)**
-   **MySQL**: 게시글, 댓글, 사용자 정보 등 데이터 저장 및 관리

#### **개발 환경 및 도구**
-   **IntelliJ IDEA / VS Code**
-   **Git / GitHub**: 버전 관리 및 협업

---

### 💡 프로젝트를 통해 얻은 경험

1.  **Full-Stack 개발 경험**: 프론트엔드(JSX)와 백엔드(Servlet)의 연동 과정을 직접 구현하며 Full-Stack 개발 흐름을 이해했습니다. 특히, 클라이언트-서버 간 데이터 통신 및 API 설계의 중요성을 체감했습니다.
2.  **MVC 패턴 이해**: Servlet 기반의 백엔드에서 데이터 모델, 뷰, 컨트롤러 역할을 분리하여 효율적인 코드 관리와 유지보수성을 높이는 경험을 했습니다.
3.  **데이터베이스 설계 및 연동**: MySQL 데이터베이스 스키마를 설계하고 JDBC를 통해 Java 애플리케이션과 연동하는 과정을 통해 데이터베이스의 CRUD 동작 원리를 깊이 있게 학습했습니다.
4.  **동적 UI 구현**: JSX의 컴포넌트 기반 접근 방식을 활용하여 사용자 인터랙션에 반응하는 동적인 웹 페이지를 구현하며 프론트엔드 개발 역량을 강화했습니다.

---

### 💬 개선 및 보완할 점

-   **프레임워크 도입**: JSX 기반의 순수 JavaScript 대신 React.js 또는 Vue.js와 같은 프론트엔드 프레임워크를 도입하여 상태 관리 및 컴포넌트 재사용성을 더욱 효율적으로 개선할 수 있습니다.
-   **보안 강화**: JWT(JSON Web Token) 기반의 인증 시스템 도입 및 SQL Injection, XSS 방어 로직 강화
-   **테스트 코드 작성**: JUnit과 같은 프레임워크를 활용하여 백엔드 API에 대한 단위 및 통합 테스트 코드 추가

---

### 🚀 시작하는 방법 (Getting Started)

1.  **레포지토리 클론:**
    ```bash
    git clone [https://github.com/leekyuhyun/contest_frontend.git](https://github.com/leekyuhyun/contest_frontend.git)
    cd contest_frontend
    ```
2.  **데이터베이스 설정:**
    -   MySQL 서버를 설치하고 실행합니다.
    -   `database.sql` (또는 유사한 이름) 파일을 참조하여 데이터베이스 및 테이블을 생성합니다.
    -   `src/main/resources/application.properties` (또는 `db.properties`) 파일에서 데이터베이스 연결 정보를 설정합니다.
3.  **백엔드 (Servlet) 실행:**
    -   IntelliJ IDEA와 같은 IDE에서 프로젝트를 열고 Tomcat 서버에 배포하여 실행합니다.
4.  **프론트엔드 (JSX) 실행:**
    -   (프로젝트 구조에 따라) 프론트엔드 디렉토리로 이동하여 `npm install` 및 `npm start` (또는 `webpack-dev-server`) 명령어를 실행합니다.
