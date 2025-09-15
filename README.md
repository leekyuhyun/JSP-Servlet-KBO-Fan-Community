# ⚾ KBO 팬 커뮤니티 (JSP + Servlet)

KBO 리그 팬들을 위한 커뮤니티 웹 애플리케이션입니다. 사용자들은 팀별 게시판에서 자유롭게 소통하고, 경기 소식 및 정보를 공유할 수 있습니다. **프론트엔드는 JSP(JavaServer Pages)를 통해 동적인 웹 페이지를 렌더링하고, 백엔드는 Java Servlet으로 비즈니스 로직과 데이터 처리를 담당했습니다.**

---

### 🔥 주요 기능 (Features)

-   **팀별 게시판**: 10개 구단별 전용 게시판을 제공하여 각 팀 팬들이 모여 소통
-   **게시글 CRUD**: 게시글 작성, 조회, 수정, 삭제 기능
-   **댓글 기능**: 게시글에 댓글을 작성하고 관리 (추가/삭제)
-   **사용자 인증**: 로그인/회원가입 기능을 통한 사용자 관리 (세션 기반)
-   **실시간 경기 스코어**: (옵션) 외부 API 연동을 통한 실시간 경기 결과 및 일정 표시
-   **반응형 디자인**: 다양한 디바이스에서 최적화된 사용자 경험 제공

---

### 🛠️ 기술 스택 (Tech Stack)

#### **프론트엔드 (Frontend)**
-   **JSP (JavaServer Pages)**: 동적인 웹 페이지 생성 및 뷰 렌더링
-   **HTML5 / CSS3**: 웹 표준 마크업 및 스타일링
-   **JavaScript (ES6+) / jQuery**: 클라이언트 측 스크립트 및 DOM 조작

#### **백엔드 (Backend)**
-   **Java Servlet**: 요청 처리, 비즈니스 로직, JSP로의 데이터 전달
-   **JDBC (Java Database Connectivity)**: MySQL 데이터베이스 연동
-   **Apache Tomcat**: 웹 애플리케이션 서버

#### **데이터베이스 (Database)**
-   **MySQL**: 게시글, 댓글, 사용자 정보 등 데이터 저장 및 관리

#### **개발 환경 및 도구**
-   **Eclipse / IntelliJ IDEA**: 개발 IDE
-   **Maven / Gradle**: 프로젝트 빌드 및 의존성 관리
-   **Git / GitHub**: 버전 관리 및 협업

---

### 💡 프로젝트를 통해 얻은 경험

1.  **MVC 패턴 구현 및 이해**: JSP와 Servlet을 활용하여 Model-View-Controller(MVC) 패턴을 직접 구현했습니다. Servlet이 Controller 역할을, JSP가 View 역할을 담당하며 데이터를 주고받는 과정을 통해 웹 애플리케이션 아키텍처에 대한 깊은 이해를 얻었습니다.
2.  **데이터베이스 연동 및 관리**: JDBC를 사용하여 Java 애플리케이션과 MySQL 데이터베이스를 연동하고, SQL 쿼리를 통해 게시글, 댓글, 사용자 정보를 효과적으로 CRUD(생성, 조회, 수정, 삭제)하는 로직을 구현했습니다.
3.  **웹 애플리케이션 배포 및 운영**: Apache Tomcat 서버에 JSP/Servlet 애플리케이션을 배포하고 운영하는 과정을 통해 웹 서버의 동작 방식과 배포 과정을 학습했습니다.
4.  **세션 기반 인증 구현**: 사용자 로그인 시 세션을 활용하여 인증 상태를 관리하고, 권한에 따른 페이지 접근 제어를 구현하며 웹 보안의 기초를 다졌습니다.

---

### 💬 개선 및 보완할 점

-   **프론트엔드 개선**: JSP의 한계를 넘어 React, Vue.js 등의 SPA(Single Page Application) 프레임워크를 도입하여 사용자 경험을 더욱 향상시키고, REST API를 분리하여 개발 효율성을 높일 수 있습니다.
-   **보안 강화**: SQL Injection, XSS 방어 로직 강화 및 민감 정보 암호화 적용.
-   **객체 관계 매핑 (ORM) 도입**: Mybatis 또는 Hibernate와 같은 ORM 프레임워크를 도입하여 JDBC 코드의 복잡성을 줄이고 생산성을 높일 수 있습니다.

---

### 🚀 시작하는 방법 (Getting Started)

1.  **레포지토리 클론:**
    ```bash
    git clone [https://github.com/leekyuhyun/contest_frontend.git](https://github.com/leekyuhyun/contest_frontend.git)
    cd contest_frontend # 프로젝트의 실제 폴더명으로 변경
    ```
2.  **데이터베이스 설정:**
    -   MySQL 서버를 설치하고 실행합니다.
    -   `database.sql` (또는 프로젝트에 맞는 SQL 파일)을 참조하여 데이터베이스 및 테이블을 생성합니다.
    -   데이터베이스 연결 정보는 `WEB-INF/web.xml` 또는 별도의 설정 파일(`db.properties` 등)에 설정합니다.
3.  **프로젝트 빌드 및 배포:**
    -   Eclipse 또는 IntelliJ IDEA에서 해당 프로젝트를 임포트합니다.
    -   Maven/Gradle을 사용하여 프로젝트를 빌드합니다.
    -   Apache Tomcat 서버에 WAR 파일 형태로 배포하거나, IDE에서 직접 서버를 실행합니다.
