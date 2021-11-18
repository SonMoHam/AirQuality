# 공기질 조회 앱
 <img width="833" alt="스크린샷 2021-11-11 오후 3 49 34" src="https://user-images.githubusercontent.com/73145656/141251329-153cd06c-1c72-40ef-a9c5-0a221a831613.png">

Google Maps SDK, Open API 활용

view1
- point A, point B 버튼을 클릭해 view2로 이동
- view2에서 설정한 값 ( 위경도, 주소, 공기질 ) 을 point A 또는 point B 라벨에 표시
- Clear 버튼 클릭 시 point A, point B 값 초기화

view2
- 맵뷰 가운데에 위치한 마커에 해당하는 지역의 주소와 공기질을 출력
- Set 버튼 클릭 시 마커가 위치한 지역의 주소, 공기질 등을 point A 또는 point B에 저장
- Set 버튼 클릭 시 point A, point B 모두 값이 있을 경우 view3으로 이동, 아닐 경우 view1로 이동
- 맵뷰 하단엔 지역 저장 내역을 테이블뷰로 보여주며, 클릭 시 해당 지역으로 맵뷰 & 마커 이동

view3
- point A, point B 라벨에 설정한 값 ( 위경도, 주소, 공기질) 표시
- Back 버튼 클릭 시 point A, point B 값 초기화 하며 view1로 이동
