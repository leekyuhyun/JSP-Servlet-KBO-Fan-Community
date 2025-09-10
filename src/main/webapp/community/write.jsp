<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="게시글 작성" />
    <jsp:param name="activeMenu" value="community" />
    <jsp:param name="customCSS" value="
        <style>
            .write-container {
                max-width: 800px;
                margin: 0 auto;
            }

            .form-section {
                background: #fff;
                border-radius: 15px;
                padding: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                margin-bottom: 20px;
            }

            .section-title {
                font-size: 1.2rem;
                font-weight: 600;
                color: #333;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #f8f9fa;
            }

            .form-control, .form-select {
                border-radius: 10px;
                border: 2px solid #e9ecef;
                padding: 12px 15px;
                font-size: 1rem;
                transition: all 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                border-color: #007bff;
                box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
            }

            .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                border-radius: 25px;
                padding: 12px 30px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.15);
            }

            .btn-secondary {
                border-radius: 25px;
                padding: 12px 30px;
                font-weight: 600;
            }

            .image-upload-area {
                border: 2px dashed #dee2e6;
                border-radius: 15px;
                padding: 40px 20px;
                text-align: center;
                background: #f8f9fa;
                transition: all 0.3s ease;
                cursor: pointer;
                position: relative;
                overflow: hidden;
            }

            .image-upload-area:hover {
                border-color: #007bff;
                background: #e3f2fd;
            }

            .image-upload-area.dragover {
                border-color: #007bff;
                background: #e3f2fd;
                transform: scale(1.02);
            }

            .upload-icon {
                font-size: 3rem;
                color: #6c757d;
                margin-bottom: 15px;
            }

            .upload-text {
                color: #6c757d;
                font-size: 1.1rem;
                margin-bottom: 10px;
            }

            .upload-hint {
                color: #adb5bd;
                font-size: 0.9rem;
            }

            .image-preview {
                display: none;
                margin-top: 20px;
                text-align: center;
            }

            .preview-image {
                max-width: 100%;
                max-height: 300px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }

            .image-info {
                margin-top: 15px;
                padding: 15px;
                background: #f8f9fa;
                border-radius: 10px;
                text-align: left;
            }

            .remove-image {
                background: #dc3545;
                color: white;
                border: none;
                border-radius: 20px;
                padding: 8px 20px;
                margin-top: 10px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .remove-image:hover {
                background: #c82333;
                transform: translateY(-1px);
            }

            .char-counter {
                text-align: right;
                color: #6c757d;
                font-size: 0.9rem;
                margin-top: 5px;
            }

            .char-counter.warning {
                color: #ffc107;
            }

            .char-counter.danger {
                color: #dc3545;
            }

            .category-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 10px;
                margin-top: 10px;
            }

            .category-option {
                position: relative;
            }

            .category-option input[type='radio'] {
                display: none;
            }

            .category-label {
                display: block;
                padding: 15px;
                border: 2px solid #e9ecef;
                border-radius: 10px;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s ease;
                background: white;
            }

            .category-option input[type='radio']:checked + .category-label {
                border-color: #007bff;
                background: #e3f2fd;
                color: #007bff;
                font-weight: 600;
            }

            .category-label:hover {
                border-color: #007bff;
                background: #f8f9fa;
            }

            .error-message {
                background: #f8d7da;
                color: #721c24;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                border: 1px solid #f5c6cb;
            }

            .loading-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                z-index: 9999;
                justify-content: center;
                align-items: center;
            }

            .loading-spinner {
                background: white;
                padding: 30px;
                border-radius: 15px;
                text-align: center;
            }

            .spinner-border {
                width: 3rem;
                height: 3rem;
            }
        </style>
    " />
</jsp:include>

<div class="container mt-4">
    <div class="write-container">
        <!-- 페이지 헤더 -->
        <div class="row mb-4">
            <div class="col-12">
                <h2 class="mb-3">
                    <i class="bi bi-pencil-square text-primary"></i> 게시글 작성
                </h2>
                <p class="text-muted">새로운 게시글을 작성해보세요!</p>
            </div>
        </div>

        <!-- 에러 메시지 -->
        <c:if test="${not empty error}">
            <div class="error-message">
                <i class="bi bi-exclamation-triangle"></i> ${error}
            </div>
        </c:if>

        <!-- 작성 폼 -->
        <form method="post" action="${pageContext.request.contextPath}/community"
              enctype="multipart/form-data" id="writeForm" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="create">

            <!-- 기본 정보 섹션 -->
            <div class="form-section">
                <div class="section-title">
                    <i class="bi bi-info-circle"></i> 기본 정보
                </div>

                <!-- 카테고리 선택 -->
                <div class="mb-4">
                    <label class="form-label fw-bold">카테고리 <span class="text-danger">*</span></label>
                    <div class="category-grid">
                        <div class="category-option">
                            <input type="radio" name="category" value="free" id="cat_free" required>
                            <label for="cat_free" class="category-label">
                                💬 자유게시판
                            </label>
                        </div>
                        <div class="category-option">
                            <input type="radio" name="category" value="analysis" id="cat_analysis">
                            <label for="cat_analysis" class="category-label">
                                📊 경기분석
                            </label>
                        </div>
                        <div class="category-option">
                            <input type="radio" name="category" value="news" id="cat_news">
                            <label for="cat_news" class="category-label">
                                📰 뉴스/소식
                            </label>
                        </div>
                        <div class="category-option">
                            <input type="radio" name="category" value="humor" id="cat_humor">
                            <label for="cat_humor" class="category-label">
                                😄 유머
                            </label>
                        </div>
                        <div class="category-option">
                            <input type="radio" name="category" value="question" id="cat_question">
                            <label for="cat_question" class="category-label">
                                ❓ 질문
                            </label>
                        </div>
                        <div class="category-option">
                            <input type="radio" name="category" value="trade" id="cat_trade">
                            <label for="cat_trade" class="category-label">
                                🔄 트레이드
                            </label>
                        </div>
                    </div>
                </div>

                <!-- 제목 입력 -->
                <div class="mb-4">
                    <label for="title" class="form-label fw-bold">제목 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="title" name="title"
                           placeholder="제목을 입력하세요" required maxlength="100"
                           value="${param.title}" oninput="updateCharCounter('title', 100)">
                    <div class="char-counter" id="titleCounter">0 / 100</div>
                </div>
            </div>

            <!-- 내용 섹션 -->
            <div class="form-section">
                <div class="section-title">
                    <i class="bi bi-file-text"></i> 내용
                </div>

                <!-- 내용 입력 -->
                <div class="mb-4">
                    <label for="content" class="form-label fw-bold">내용 <span class="text-danger">*</span></label>
                    <textarea class="form-control" id="content" name="content" rows="10"
                              placeholder="내용을 입력하세요" required maxlength="2000"
                              oninput="updateCharCounter('content', 2000)">${param.content}</textarea>
                    <div class="char-counter" id="contentCounter">0 / 2000</div>
                </div>
            </div>

            <!-- 이미지 업로드 섹션 -->
            <div class="form-section">
                <div class="section-title">
                    <i class="bi bi-image"></i> 이미지 첨부 (선택사항)
                </div>

                <div class="image-upload-area" onclick="document.getElementById('imageInput').click()"
                     ondrop="handleDrop(event)" ondragover="handleDragOver(event)"
                     ondragleave="handleDragLeave(event)" id="uploadArea">
                    <div class="upload-icon">
                        <i class="bi bi-cloud-upload"></i>
                    </div>
                    <div class="upload-text">
                        클릭하거나 파일을 드래그하여 이미지를 업로드하세요
                    </div>
                    <div class="upload-hint">
                        JPG, PNG, GIF 파일만 지원 (최대 5MB)
                    </div>
                </div>

                <input type="file" id="imageInput" name="image" accept="image/*"
                       style="display: none;" onchange="handleFileSelect(event)">

                <!-- 이미지 미리보기 -->
                <div class="image-preview" id="imagePreview">
                    <img id="previewImg" class="preview-image" alt="미리보기">
                    <div class="image-info" id="imageInfo">
                        <div><strong>파일명:</strong> <span id="fileName"></span></div>
                        <div><strong>크기:</strong> <span id="fileSize"></span></div>
                        <div><strong>타입:</strong> <span id="fileType"></span></div>
                    </div>
                    <button type="button" class="remove-image" onclick="removeImage()">
                        <i class="bi bi-trash"></i> 이미지 제거
                    </button>
                </div>
            </div>

            <!-- 버튼 섹션 -->
            <div class="form-section">
                <div class="row">
                    <div class="col-md-6">
                        <a href="${pageContext.request.contextPath}/community" class="btn btn-secondary w-100">
                            <i class="bi bi-arrow-left"></i> 취소
                        </a>
                    </div>
                    <div class="col-md-6">
                        <button type="submit" class="btn btn-primary w-100" id="submitBtn">
                            <i class="bi bi-check-lg"></i> 게시글 작성
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- 로딩 오버레이 -->
<div class="loading-overlay" id="loadingOverlay">
    <div class="loading-spinner">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <div class="mt-3">게시글을 작성 중입니다...</div>
    </div>
</div>

<script>
    // 페이지 로드 시 초기화
    document.addEventListener('DOMContentLoaded', function() {
        updateCharCounter('title', 100);
        updateCharCounter('content', 2000);
    });

    // 글자 수 카운터 업데이트
    function updateCharCounter(fieldId, maxLength) {
        const field = document.getElementById(fieldId);
        const counter = document.getElementById(fieldId + 'Counter');
        const currentLength = field.value.length;

        counter.textContent = currentLength + ' / ' + maxLength;

        // 색상 변경
        counter.className = 'char-counter';
        if (currentLength > maxLength * 0.9) {
            counter.classList.add('danger');
        } else if (currentLength > maxLength * 0.7) {
            counter.classList.add('warning');
        }
    }

    // 드래그 앤 드롭 처리
    function handleDragOver(event) {
        event.preventDefault();
        document.getElementById('uploadArea').classList.add('dragover');
    }

    function handleDragLeave(event) {
        event.preventDefault();
        document.getElementById('uploadArea').classList.remove('dragover');
    }

    function handleDrop(event) {
        event.preventDefault();
        document.getElementById('uploadArea').classList.remove('dragover');

        const files = event.dataTransfer.files;
        if (files.length > 0) {
            handleFile(files[0]);
        }
    }

    // 파일 선택 처리
    function handleFileSelect(event) {
        const file = event.target.files[0];
        if (file) {
            handleFile(file);
        }
    }

    // 파일 처리
    function handleFile(file) {
        // 파일 타입 검사
        if (!file.type.startsWith('image/')) {
            alert('이미지 파일만 업로드할 수 있습니다.');
            return;
        }

        // 파일 크기 검사 (5MB)
        if (file.size > 5 * 1024 * 1024) {
            alert('파일 크기는 5MB 이하여야 합니다.');
            return;
        }

        // 미리보기 표시
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('previewImg').src = e.target.result;
            document.getElementById('fileName').textContent = file.name;
            document.getElementById('fileSize').textContent = formatFileSize(file.size);
            document.getElementById('fileType').textContent = file.type;

            document.getElementById('uploadArea').style.display = 'none';
            document.getElementById('imagePreview').style.display = 'block';
        };
        reader.readAsDataURL(file);

        // 파일 input에 설정
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(file);
        document.getElementById('imageInput').files = dataTransfer.files;
    }

    // 이미지 제거
    function removeImage() {
        document.getElementById('imageInput').value = '';
        document.getElementById('uploadArea').style.display = 'block';
        document.getElementById('imagePreview').style.display = 'none';
    }

    // 파일 크기 포맷팅
    function formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }

    // 폼 유효성 검사
    function validateForm() {
        const title = document.getElementById('title').value.trim();
        const content = document.getElementById('content').value.trim();
        const category = document.querySelector('input[name="category"]:checked');

        if (!category) {
            alert('카테고리를 선택해주세요.');
            return false;
        }

        if (title.length === 0) {
            alert('제목을 입력해주세요.');
            document.getElementById('title').focus();
            return false;
        }

        if (title.length > 100) {
            alert('제목은 100자 이하로 입력해주세요.');
            document.getElementById('title').focus();
            return false;
        }

        if (content.length === 0) {
            alert('내용을 입력해주세요.');
            document.getElementById('content').focus();
            return false;
        }

        if (content.length > 2000) {
            alert('내용은 2000자 이하로 입력해주세요.');
            document.getElementById('content').focus();
            return false;
        }

        // 로딩 표시
        document.getElementById('loadingOverlay').style.display = 'flex';
        document.getElementById('submitBtn').disabled = true;

        return true;
    }

    // 뒤로가기 시 로딩 숨김
    window.addEventListener('pageshow', function(event) {
        if (event.persisted) {
            document.getElementById('loadingOverlay').style.display = 'none';
            document.getElementById('submitBtn').disabled = false;
        }
    });
</script>

<jsp:include page="../includes/footer.jsp" />