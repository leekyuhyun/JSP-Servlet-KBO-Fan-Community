-- 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS kbo_community;
USE kbo_community;

-- Team 테이블 생성
CREATE TABLE Team (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    logo VARCHAR(255),
    official_site VARCHAR(255)
);
ALTER TABLE Team ADD COLUMN team_color VARCHAR(20) AFTER official_site;
ALTER TABLE Team ADD COLUMN stadium_name VARCHAR(100) AFTER team_color;
ALTER TABLE Team ADD COLUMN stadium_address VARCHAR(255) AFTER stadium_name;
ALTER TABLE Team ADD COLUMN stadium_lat DOUBLE AFTER stadium_address;
ALTER TABLE Team ADD COLUMN stadium_lng DOUBLE AFTER stadium_lat;
ALTER TABLE Team ADD COLUMN description TEXT AFTER stadium_lng;
ALTER TABLE Team ADD COLUMN founded_year INT AFTER description;
ALTER TABLE Team ADD COLUMN primary_color VARCHAR(7) DEFAULT '#1976D2';
ALTER TABLE Team ADD COLUMN secondary_color VARCHAR(7) DEFAULT '#BBDEFB';
ALTER TABLE Team ADD COLUMN wins INT DEFAULT 0;
ALTER TABLE Team ADD COLUMN losses INT DEFAULT 0;
ALTER TABLE Team ADD COLUMN draws INT DEFAULT 0;
ALTER TABLE Team 
ADD COLUMN championships INT DEFAULT 0 AFTER draws,
ADD COLUMN championship_years TEXT AFTER championships;
ALTER TABLE Team ADD COLUMN long_description TEXT AFTER description;


-- Team 테이블 데이터 삽입
INSERT INTO Team (name, logo, official_site) VALUES
('KIA 타이거즈', '/img/KIA 타이거즈.png', 'https://www.tigers.co.kr/'),
('KT 위즈', '/img/KT 위즈.png', 'https://www.ktwiz.co.kr/'),
('LG 트윈스', '/img/LG 트윈스.png', 'https://www.lgtwins.com/'),
('NC 다이노스', '/img/NC 다이노스.png', 'https://www.ncdinos.com/'),
('SSG 랜더스', '/img/SSG 랜더스.png', 'https://www.ssglanders.com/'),
('두산 베어스', '/img/두산 베어스.png', 'https://www.doosanbears.com/'),
('롯데 자이언츠', '/img/롯데 자이언츠.png', 'https://www.giantsclub.com/'),
('삼성 라이온즈', '/img/삼성 라이온즈.png', 'https://www.samsunglions.com/'),
('키움 히어로즈', '/img/키움 히어로즈.png', 'https://www.heroesbaseball.co.kr/'),
('한화 이글스', '/img/한화 이글스.png', 'https://www.hanwhaeagles.co.kr/');
UPDATE Team SET championships = 12, championship_years = '1983,1986,1987,1988,1989,1991,1993,1996,1997,2009,2017,2024' WHERE name = 'KIA 타이거즈';
UPDATE Team SET championships = 8, championship_years = '1985,2002,2005,2006,2011,2012,2013,2014' WHERE name = '삼성 라이온즈';
UPDATE Team SET championships = 6, championship_years = '1982,1995,2001,2015,2016,2019' WHERE name = '두산 베어스';
UPDATE Team SET championships = 5, championship_years = '2007,2008,2010,2018,2022' WHERE name = 'SSG 랜더스';
UPDATE Team SET championships = 3, championship_years = '1990,1994,2023' WHERE name = 'LG 트윈스';
UPDATE Team SET championships = 2, championship_years = '1984,1992' WHERE name = '롯데 자이언츠';
UPDATE Team SET championships = 1, championship_years = '1999' WHERE name = '한화 이글스';
UPDATE Team SET championships = 1, championship_years = '2021' WHERE name = 'KT 위즈';
UPDATE Team SET championships = 1, championship_years = '2020' WHERE name = 'NC 다이노스';
UPDATE Team SET championships = 0, championship_years = '' WHERE name = '키움 히어로즈';

UPDATE Team SET long_description = '광주광역시를 연고지로 하는 KIA 타이거즈는 KBO 리그의 원년인 1982년부터 참여한 해태 타이거즈를 전신으로 합니다. 해태 시절부터 압도적인 성적을 기록하며 KBO 리그 역사상 가장 많은 한국시리즈 우승 트로피를 들어 올린 명문 구단으로 불립니다. ''왕조'' 시대를 구축하며 수많은 스타 플레이어를 배출했으며, 역동적이고 공격적인 야구로 팬들에게 강한 인상을 남겼습니다. 해태와 KIA를 합쳐 총 12번의 한국시리즈 우승을 차지했습니다.'  where name = 'KIA 타이거즈';
UPDATE Team SET long_description = '대구광역시를 연고지로 하는 삼성 라이온즈 역시 1982년 출범 당시부터 함께한 원년 구단입니다. KBO 리그 역사상 단일 구단으로는 가장 많은 통합 우승(정규시즌 우승과 한국시리즈 우승 동시 달성)을 기록하며 ''삼성 왕조'' 시대를 열기도 했습니다. 특히 2011년부터 2014년까지 4년 연속 통합 우승이라는 대기록을 세웠습니다. 안정적인 팀 운영과 선수 육성으로 꾸준히 상위권을 유지해왔으며, 총 8번의 한국시리즈 우승을 차지했습니다.' where name = '삼성 라이온즈';
UPDATE Team SET long_description = '서울특별시를 연고지로 사용하며 잠실 야구장을 홈으로 쓰는 두산 베어스는 KBO 리그가 시작된 1982년, 리그 첫 경기를 치르고 원년 우승을 달성한 OB 베어스를 전신으로 합니다. 오랜 역사만큼이나 많은 팬을 보유하고 있으며, 꾸준히 한국시리즈에 진출하며 강팀의 면모를 보여왔습니다. 특히 2015년부터 2020년까지 6년 연속 한국시리즈에 진출하는 등 ''화수분 야구''로 불리는 탄탄한 선수 육성 시스템을 자랑합니다. 총 6번의 한국시리즈 우승 기록을 가지고 있습니다.' where name = '두산 베어스';
UPDATE Team SET long_description = '인천광역시를 연고지로 하는 SSG 랜더스는 SK 와이번스를 전신으로 2021년 새롭게 창단된 구단입니다. ''착륙(Landing)''을 의미하는 팀명처럼 KBO 리그에 신선한 바람을 일으키며 등장했습니다. 전신인 SK 와이번스는 4번의 한국시리즈 우승을 기록했으며, SSG 랜더스는 2022년 KBO 리그 최초로 ''와이어 투 와이어'' 정규시즌 우승을 달성하고 한국시리즈까지 제패하며 1번의 우승을 추가했습니다. SK와 SSG를 합쳐 총 5번의 한국시리즈 우승 역사를 이어가고 있습니다.' where name = 'SSG 랜더스';
UPDATE Team SET long_description = '서울특별시를 연고지로 두산 베어스와 함께 잠실 야구장을 홈으로 사용하는 LG 트윈스는 1982년 KBO 리그 원년 구단인 MBC 청룡을 전신으로 하여 1990년 새롭게 출발했습니다. ''신바람 야구''라는 별명처럼 역동적인 플레이 스타일을 추구하며 많은 사랑을 받아왔습니다. 창단 첫해인 1990년 한국시리즈 우승을 차지했고, 1994년에도 우승을 추가했습니다. 이후 오랜 기간 우승에 도전한 끝에 2023년 다시 한번 한국시리즈 정상에 오르며 통산 3번째 우승을 달성했습니다.' where name = 'LG 트윈스';
UPDATE Team SET long_description = '부산광역시를 연고지로 하는 롯데 자이언츠는 1982년 KBO 리그 출범과 함께 창단되었습니다. ''구도(球都)'' 부산의 뜨거운 야구 열기를 상징하는 구단으로, KBO 리그에서 가장 열정적이고 많은 팬을 가진 구단 중 하나로 꼽힙니다. 비록 다른 구단에 비해 우승 횟수는 적지만, 매 시즌 사직 야구장을 가득 채우는 팬들의 응원은 KBO 리그의 명물로 통합니다. 한국시리즈에서 총 2번의 우승을 경험했습니다.' where name = '롯데 자이언츠';
UPDATE Team SET long_description = '대전광역시를 연고지로 하는 한화 이글스는 1982년 빙그레 이글스로 창단하여 1993년 현재의 이름으로 변경되었습니다. ''이글스''라는 이름처럼 불타는 투지와 끈끈한 조직력을 바탕으로 경기에 임하며 팬들에게 깊은 인상을 남겨왔습니다. 1999년 창단 첫 한국시리즈 우승을 달성하며 오랜 기다림을 끝냈습니다. 비록 최근 몇 년간 어려운 시기를 겪었지만, 다시 도약을 위한 노력을 계속하고 있는 구단입니다. 총 1번의 한국시리즈 우승 기록을 가지고 있습니다.' where name = '한화 이글스';
UPDATE Team SET long_description = '경기도 수원시를 연고지로 하는 KT 위즈는 2013년 창단하여 2015년부터 1군 리그에 합류한 구단입니다. KBO 리그의 막내 구단이지만, 빠르게 전력을 강화하며 단숨에 강팀으로 성장했습니다. 2021년에는 창단 처음으로 정규시즌 우승에 이어 한국시리즈까지 제패하며 통합 우승을 달성하는 기염을 토했습니다. 짧은 역사에도 불구하고 1번의 한국시리즈 우승을 기록하며 만년 하위팀 이미지를 벗고 신흥 강호로 발돋움했습니다.' where name = 'KT 위즈';
UPDATE Team SET long_description = '경상남도 창원시를 연고지로 하는 NC 다이노스는 2011년 창단하여 2013년부터 KBO 1군 리그에 참가했습니다. 창단 초기부터 젊고 패기 넘치는 팀 컬러로 팬들에게 신선한 인상을 주었으며, 빠르게 강팀으로 성장했습니다. 2020년 창단 첫 정규시즌 우승에 이어 한국시리즈에서도 승리하며 1번의 통합 우승을 달성했습니다. 혁신적인 시도와 데이터 기반 야구로 주목받고 있습니다.' where name = 'NC 다이노스';
UPDATE Team SET long_description = '서울특별시를 연고지로 하며 고척 스카이돔을 홈 구장으로 사용하는 키움 히어로즈는 2008년 우리 히어로즈로 창단한 후 여러 차례 스폰서십 변경으로 구단 명칭이 바뀌었습니다. 재정적 어려움 속에서도 효율적인 운영과 뛰어난 선수 육성으로 꾸준히 포스트시즌에 진출하며 ''스몰 마켓의 반란''을 보여주었습니다. 아직 한국시리즈 우승 기록은 없지만, 리그의 다크호스로서 항상 강력한 전력을 유지하고 있습니다.' where name = '키움 히어로즈';

SET SQL_SAFE_UPDATES = 0;
UPDATE Team SET 
    team_color = '#EA0029', 
    stadium_name = '광주 KIA챔피언스필드',
    stadium_address = '광주광역시 북구 서림로 10',
    stadium_lat = 35.1682,
    stadium_lng = 126.8905,
    description = 'KIA 타이거즈는 광주광역시를 연고지로 하는 프로야구단으로, 한국 프로야구의 원년 멤버입니다. 통산 11회 한국시리즈 우승을 차지한 명문 구단입니다.',
    founded_year = 1982
WHERE name = 'KIA 타이거즈';

UPDATE Team SET 
    team_color = '#001C54', 
    stadium_name = '수원 KT위즈파크',
    stadium_address = '경기도 수원시 장안구 경수대로 893',
    stadium_lat = 37.2995,
    stadium_lng = 127.0096,
    description = 'KT 위즈는 경기도 수원시를 연고지로 하는 프로야구단으로, 2015년 KBO 리그에 10번째 구단으로 합류했습니다. 2021년 창단 첫 한국시리즈 우승을 차지했습니다.',
    founded_year = 2013
WHERE name = 'KT 위즈';

UPDATE Team SET 
    team_color = '#C30452', 
    stadium_name = '서울 잠실야구장',
    stadium_address = '서울특별시 송파구 올림픽로 25',
    stadium_lat = 37.5121,
    stadium_lng = 127.0718,
    description = 'LG 트윈스는 서울특별시를 연고지로 하는 프로야구단으로, 한국 프로야구의 원년 멤버입니다. 2번의 한국시리즈 우승을 차지했습니다.',
    founded_year = 1982
WHERE name = 'LG 트윈스';

UPDATE Team SET 
    team_color = '#315288', 
    stadium_name = '창원 NC파크',
    stadium_address = '경상남도 창원시 마산회원구 삼호로 63',
    stadium_lat = 35.2203,
    stadium_lng = 128.5827,
    description = 'NC 다이노스는 경상남도 창원시를 연고지로 하는 프로야구단으로, 2013년 KBO 리그에 9번째 구단으로 합류했습니다. 2020년 창단 첫 한국시리즈 우승을 차지했습니다.',
    founded_year = 2011
WHERE name = 'NC 다이노스';

UPDATE Team SET 
    team_color = '#CE0E2D', 
    stadium_name = '인천 SSG랜더스필드',
    stadium_address = '인천광역시 미추홀구 매소홀로 618',
    stadium_lat = 37.4374,
    stadium_lng = 126.6930,
    description = 'SSG 랜더스는 인천광역시를 연고지로 하는 프로야구단으로, 2000년 창단된 SK 와이번스의 후신입니다. 2022년 한국시리즈 우승을 차지했습니다.',
    founded_year = 2000
WHERE name = 'SSG 랜더스';

UPDATE Team SET 
    team_color = '#131230', 
    stadium_name = '서울 잠실야구장',
    stadium_address = '서울특별시 송파구 올림픽로 25',
    stadium_lat = 37.5121,
    stadium_lng = 127.0718,
    description = '두산 베어스는 서울특별시를 연고지로 하는 프로야구단으로, 한국 프로야구의 원년 멤버입니다. 통산 6회 한국시리즈 우승을 차지했습니다.',
    founded_year = 1982
WHERE name = '두산 베어스';

UPDATE Team SET 
    team_color = '#002955', 
    stadium_name = '부산 사직야구장',
    stadium_address = '부산광역시 동래구 사직로 45',
    stadium_lat = 35.1942,
    stadium_lng = 129.0616,
    description = '롯데 자이언츠는 부산광역시를 연고지로 하는 프로야구단으로, 한국 프로야구의 원년 멤버입니다. 2회 한국시리즈 우승을 차지했습니다.',
    founded_year = 1982
WHERE name = '롯데 자이언츠';

UPDATE Team SET 
    team_color = '#0066B3', 
    stadium_name = '대구 삼성라이온즈파크',
    stadium_address = '대구광역시 수성구 야구전설로 1',
    stadium_lat = 35.8411,
    stadium_lng = 128.6894,
    description = '삼성 라이온즈는 대구광역시를 연고지로 하는 프로야구단으로, 한국 프로야구의 원년 멤버입니다. 통산 8회 한국시리즈 우승을 차지했습니다.',
    founded_year = 1982
WHERE name = '삼성 라이온즈';

UPDATE Team SET 
    team_color = '#820024', 
    stadium_name = '서울 고척스카이돔',
    stadium_address = '서울특별시 구로구 경인로 430',
    stadium_lat = 37.4982,
    stadium_lng = 126.8668,
    description = '키움 히어로즈는 서울특별시를 연고지로 하는 프로야구단으로, 2008년 우리 히어로즈로 창단되었습니다.',
    founded_year = 2008
WHERE name = '키움 히어로즈';

UPDATE Team SET 
    team_color = '#FF6600', 
    stadium_name = '대전 한화생명볼파크',
    stadium_address = '대전광역시 중구 대종로 373',
    stadium_lat = 36.3172,
    stadium_lng = 127.4292,
    description = '한화 이글스는 대전광역시를 연고지로 하는 프로야구단으로, 한국 프로야구의 원년 멤버입니다. 1999년 한국시리즈 우승을 차지했습니다.',
    founded_year = 1986
WHERE name = '한화 이글스';

UPDATE Team SET primary_color = '#E31937', secondary_color = '#FFFFFF' WHERE name = 'KIA 타이거즈';
UPDATE Team SET primary_color = '#001C54', secondary_color = '#FF0000' WHERE name = 'KT 위즈';
UPDATE Team SET primary_color = '#C30452', secondary_color = '#FFFFFF' WHERE name = 'LG 트윈스';
UPDATE Team SET primary_color = '#315288', secondary_color = '#FFFFFF' WHERE name = 'NC 다이노스';
UPDATE Team SET primary_color = '#CE0E2D', secondary_color = '#000000' WHERE name = 'SSG 랜더스';
UPDATE Team SET primary_color = '#131230', secondary_color = '#FFFFFF' WHERE name = '두산 베어스';
UPDATE Team SET primary_color = '#002856', secondary_color = '#D60F0F' WHERE name = '롯데 자이언츠';
UPDATE Team SET primary_color = '#0066B3', secondary_color = '#0E4C92' WHERE name = '삼성 라이온즈';
UPDATE Team SET primary_color = '#820024', secondary_color = '#FFFFFF' WHERE name = '키움 히어로즈';
UPDATE Team SET primary_color = '#FF6600', secondary_color = '#000000' WHERE name = '한화 이글스';

-- User 테이블 생성
CREATE TABLE User (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(10) NOT NULL,
    login_id VARCHAR(20) NOT NULL UNIQUE,
    nickname VARCHAR(20) NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(50) NOT NULL,
    team_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (team_id) REFERENCES Team(team_id)
);

-- Game 테이블 생성 (경기 일정 및 결과)
CREATE TABLE Game (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    game_date DATE NOT NULL,
    game_time VARCHAR(10) NOT NULL,
    stadium VARCHAR(50) NOT NULL,
    away_team INT NOT NULL,
    home_team INT NOT NULL,
    away_score INT,
    home_score INT,
    away_pitcher VARCHAR(20),
    away_pitcher_result VARCHAR(5),
    home_pitcher VARCHAR(20),
    home_pitcher_result VARCHAR(5),
    winner VARCHAR(20),
    etc VARCHAR(100),
    FOREIGN KEY (away_team) REFERENCES Team(team_id),
    FOREIGN KEY (home_team) REFERENCES Team(team_id)
);
ALTER TABLE game ADD COLUMN status VARCHAR(20) DEFAULT 'SCHEDULED' AFTER etc;
drop table Game;

-- 커뮤니티 게시글 테이블 (기존 posts 테이블을 community로 통합)
CREATE TABLE community (
    community_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author_id INT NOT NULL,
    category VARCHAR(50) NOT NULL DEFAULT 'free',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    view_count INT DEFAULT 0,
    like_count INT DEFAULT 0,
    comment_count INT DEFAULT 0,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (author_id) REFERENCES User(user_id) ON DELETE CASCADE,
    INDEX idx_category (category),
    INDEX idx_created_at (created_at),
    INDEX idx_author_id (author_id)
);
ALTER TABLE community ADD COLUMN image_path VARCHAR(500);
ALTER TABLE community ADD COLUMN original_filename VARCHAR(255);
-- 댓글 테이블 (community_id로 참조하도록 수정)
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    community_id INT NOT NULL,
    content TEXT NOT NULL,
    author_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    like_count INT DEFAULT 0,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (community_id) REFERENCES community(community_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES User(user_id) ON DELETE CASCADE,
    INDEX idx_community_id (community_id),
    INDEX idx_author_id (author_id),
    INDEX idx_created_at (created_at)
);

-- 커뮤니티 게시글 좋아요 테이블 (기존 post_likes를 community_likes로 변경)
CREATE TABLE community_likes (
    community_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (community_id, user_id),
    FOREIGN KEY (community_id) REFERENCES community(community_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

-- 댓글 좋아요 테이블 (그대로 유지)
CREATE TABLE comment_likes (
    comment_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (comment_id, user_id),
    FOREIGN KEY (comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);
CREATE TABLE game_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    game_date DATE NOT NULL,
    stadium VARCHAR(100) NOT NULL,
    home_team VARCHAR(50) NOT NULL,
    away_team VARCHAR(50) NOT NULL,
    home_score INT NOT NULL,
    away_score INT NOT NULL,
    seat VARCHAR(100),
    memo TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);
-- 카테고리별 인덱스 및 성능 최적화
CREATE INDEX idx_community_category_created ON community(category, created_at DESC);
CREATE INDEX idx_comments_community_created ON comments(community_id, created_at DESC);

select * from user;
select * from team;
select * from game;
select * from community;
select * from community_likes;
select * from comments;
select * from game_records;