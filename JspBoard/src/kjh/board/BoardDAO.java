package kjh.board;

import java.sql.*;
import java.util.*; //ArrayList, List를 사용

//DB에 접속해서 웹상에서 호출할 메서드를 작성하는 클래스.
public class BoardDAO {
	private DBConnectionMgr pool = null; //1. 가져올 객체를 멤버변수로 선언한다.
	Connection con = null; //접속객체
	PreparedStatement pstmt = null; //sql문을 넣을 곳
	ResultSet rs = null; // 초기값 (select값을 테이블 형태로 받기 위해 필요)
	String sql = ""; //sql구문을 저장할 변수
	
	public BoardDAO(){//2. 생성자 - 초기값 설정
		//DB를 연결하지 못했다면
		try {
			pool = DBConnectionMgr.getInstance(); //정적메서드는 클래스명.정적메서드명(); 으로 호출
			System.out.println("pool=>" + pool);
		}catch(Exception e) {
			System.out.println("DB연결 실패(pool을 얻어오지 못함)=>" + e);
		}
	}
	
	//1. 총 레코드수를 구해주는 메서드 필요
		//메서드 만드는 규칙 -> 제일 먼저 SQL문을 적어본다.
		//형식) select count(*) from board;
	//웹상에서의 접근지정자는 거의 다 public, select는 반환형이 있다., where조건이 없으면 매개변수 없다. 
	public int getArticleCount() {
		//1. DB접속 구문
		int x = 0;
		//2. SQL구문 - 오류가 발생할 때 해결하기 위함.
		try {
			con = pool.getConnection(); //con은 pool객체에서 얻어온다. (10개 중에서 한 개를 빌려준다) -> default값이 10이다.
			                                      // -> 커넥션 풀 (필요할 때마다 객체(connection)를 빌려주고, 필요 없으면 반납한다.)
			                                     //미리 만들어서 빌려준다. (약간 워터파크의 구명조끼 같은 느낌...?)
			System.out.println("con=>" + con);
			sql = "select count(*) from board"; //count(*)는 필드가 아니다. 
			pstmt = con.prepareStatement(sql);//sql문장실행
			rs = pstmt.executeQuery(); //select문이기 때문에 executeQuery()를 쓴다.
			
			//총 레코드 수를 구했다면
			if(rs.next()) {
				x = rs.getInt(1); //count(*)는 필드가 아니기 때문에 필드명으로 불러올 수가 없다. (그룹함수의 결과물이기 때문에)
			}
		}catch(Exception e) {
			System.out.println("getArticleCount()메서드 호출 에러 =>" + e);
		}
		finally{//3. 메모리 해제, 종료
			pool.freeConnection(con, pstmt, rs); //con.close(), pstmt.close(), rs.close()
		}
		return x; //반환값이 있으니까 리턴!
	}
	
	
	
	
	//2. 글 목록 보기에 대한 메서드 구현 -> 범위를 지정 / zipcode를 가지고 구현해볼 것임
	                         //레코드 시작번호, 불러올 레코드의 개수
	public List getArticles (int start, int end){//레코드가 여러개이기 때문에
			//1. DB접속 구문
			List articleList = null; // = ArrayList articleList = null; 
			
			//2. SQL구문 - 오류가 발생할 때 해결하기 위함.
			try {
				con = pool.getConnection(); //con은 pool객체에서 얻어온다. (10개 중에서 한 개를 빌려준다) -> default값이 10이다.
				                                      // -> 커넥션 풀 (필요할 때마다 객체(connection)를 빌려주고, 필요 없으면 반납한다.)
				                                     //미리 만들어서 빌려준다. (약간 워터파크의 구명조끼 같은 느낌...?)
				System.out.println("con=>" + con);
				sql = "select * from board order by ref desc, re_step asc, limit ?,?"; //ref -> 그룹번호, desc->내림차순 / limit ?,? -> ?부터 ?까지 해당하는 것만 보여달라~
				pstmt = con.prepareStatement(sql);//sql문장실행
				pstmt.setInt(1, start-1); //sql문장에 ?가 있으니 값을 넣어주자  / MySQL은 레코드순번이 내부적으로 0부터 시작하기 때문에 -1을 빼준다.
				pstmt.setInt(2, end);
				rs = pstmt.executeQuery(); //select문이기 때문에 executeQuery()를 쓴다.
				
				//총 레코드 수를 구했다면
				if(rs.next()) { //레코드가 한개라도 존재한다면
					//articleList = new List(); 인터페이스는 자기 자신은 객체를 생성할 수 없다. 
					articleList = new ArrayList(end); //화면에 보여질 게시글은 end개수 만큼.(end개수만큼 데이터를 담을 공간 생성)
					do { //찾은 레코드의 필드별로 저장
						BoardDTO article = new BoardDTO();
						article.setNum(rs.getInt("num"));//게시물 번호를 불러온다. 
						article.setWriter(rs.getString("writer"));
						article.setEmail(rs.getString("email"));
						article.setSubject(rs.getString("subject"));
						article.setPasswd(rs.getString("passwd"));
						article.setContent(rs.getString("content"));
						article.setIp(rs.getString("ip"));
						
						article.setRegdate(rs.getTimestamp("reg_date"));//작성날짜 (오늘날짜)
						article.setReadcount(rs.getInt("readcount")); //조회수
						
						//-----------------댓글----------------
						article.setRef(rs.getInt("ref")); //그룹번호
						article.setRe_step(rs.getInt("re_step")); //답변글 순서
						article.setRe_level(rs.getInt("re_level")); //답변의 깊이 
						//-------------------------------------
						
						article.setContent(rs.getString("content"));
						article.setIp(rs.getNString("ip"));
						
						//추가하기
						articleList.add(article); //위의 레코드들을 articleList에 추가해줌. 
					}while(rs.next());
				}
			}catch(Exception e) {
				System.out.println("getArticles()메서드 호출 에러 =>" + e);
			}
			finally{//3. 메모리 해제, 종료
				pool.freeConnection(con, pstmt, rs); //con.close(), pstmt.close(), rs.close()
			}
			return articleList; //list.jsp에서 articleList를 for문을 만들 것임.
	}
}
