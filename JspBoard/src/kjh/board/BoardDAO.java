package kjh.board;

import java.sql.*;
import java.util.*; //ArrayList, List�� ���

//DB�� �����ؼ� ���󿡼� ȣ���� �޼��带 �ۼ��ϴ� Ŭ����.
public class BoardDAO {
	private DBConnectionMgr pool = null; //1. ������ ��ü�� ��������� �����Ѵ�.
	Connection con = null; //���Ӱ�ü
	PreparedStatement pstmt = null; //sql���� ���� ��
	ResultSet rs = null; // �ʱⰪ (select���� ���̺� ���·� �ޱ� ���� �ʿ�)
	String sql = ""; //sql������ ������ ����
	
	public BoardDAO(){//2. ������ - �ʱⰪ ����
		//DB�� �������� ���ߴٸ�
		try {
			pool = DBConnectionMgr.getInstance(); //�����޼���� Ŭ������.�����޼����(); ���� ȣ��
			System.out.println("pool=>" + pool);
		}catch(Exception e) {
			System.out.println("DB���� ����(pool�� ������ ����)=>" + e);
		}
	}
	
	//1. �� ���ڵ���� �����ִ� �޼��� �ʿ�
		//�޼��� ����� ��Ģ -> ���� ���� SQL���� �����.
		//����) select count(*) from board;
	//���󿡼��� ���������ڴ� ���� �� public, select�� ��ȯ���� �ִ�., where������ ������ �Ű����� ����. 
	public int getArticleCount() {
		//1. DB���� ����
		int x = 0;
		//2. SQL���� - ������ �߻��� �� �ذ��ϱ� ����.
		try {
			con = pool.getConnection(); //con�� pool��ü���� ���´�. (10�� �߿��� �� ���� �����ش�) -> default���� 10�̴�.
			                                      // -> Ŀ�ؼ� Ǯ (�ʿ��� ������ ��ü(connection)�� �����ְ�, �ʿ� ������ �ݳ��Ѵ�.)
			                                     //�̸� ���� �����ش�. (�ణ ������ũ�� �������� ���� ����...?)
			System.out.println("con=>" + con);
			sql = "select count(*) from board"; //count(*)�� �ʵ尡 �ƴϴ�. 
			pstmt = con.prepareStatement(sql);//sql�������
			rs = pstmt.executeQuery(); //select���̱� ������ executeQuery()�� ����.
			
			//�� ���ڵ� ���� ���ߴٸ�
			if(rs.next()) {
				x = rs.getInt(1); //count(*)�� �ʵ尡 �ƴϱ� ������ �ʵ������ �ҷ��� ���� ����. (�׷��Լ��� ������̱� ������)
			}
		}catch(Exception e) {
			System.out.println("getArticleCount()�޼��� ȣ�� ���� =>" + e);
		}
		finally{//3. �޸� ����, ����
			pool.freeConnection(con, pstmt, rs); //con.close(), pstmt.close(), rs.close()
		}
		return x; //��ȯ���� �����ϱ� ����!
	}
	
	
	
	
	//2. �� ��� ���⿡ ���� �޼��� ���� -> ������ ���� / zipcode�� ������ �����غ� ����
	                         //���ڵ� ���۹�ȣ, �ҷ��� ���ڵ��� ����
	public List getArticles (int start, int end){//���ڵ尡 �������̱� ������
			//1. DB���� ����
			List articleList = null; // = ArrayList articleList = null; 
			
			//2. SQL���� - ������ �߻��� �� �ذ��ϱ� ����.
			try {
				con = pool.getConnection(); //con�� pool��ü���� ���´�. (10�� �߿��� �� ���� �����ش�) -> default���� 10�̴�.
				                                      // -> Ŀ�ؼ� Ǯ (�ʿ��� ������ ��ü(connection)�� �����ְ�, �ʿ� ������ �ݳ��Ѵ�.)
				                                     //�̸� ���� �����ش�. (�ణ ������ũ�� �������� ���� ����...?)
				System.out.println("con=>" + con);
				sql = "select * from board order by ref desc, re_step asc limit ?,?"; //ref -> �׷��ȣ, desc->�������� / limit ?,? -> ?���� ?���� �ش��ϴ� �͸� �����޶�~
				pstmt = con.prepareStatement(sql);//sql�������
				pstmt.setInt(1, start-1); //sql���忡 ?�� ������ ���� �־�����  / MySQL�� ���ڵ������ ���������� 0���� �����ϱ� ������ -1�� ���ش�.
				pstmt.setInt(2, end);
				rs = pstmt.executeQuery(); //select���̱� ������ executeQuery()�� ����.
				
				//�� ���ڵ� ���� ���ߴٸ�
				if(rs.next()) { //���ڵ尡 �Ѱ��� �����Ѵٸ�
					//articleList = new List(); �������̽��� �ڱ� �ڽ��� ��ü�� ������ �� ����. 
					articleList = new ArrayList(end); //ȭ�鿡 ������ �Խñ��� end���� ��ŭ.(end������ŭ �����͸� ���� ���� ����)
					do { //ã�� ���ڵ��� �ʵ庰�� ����
						BoardDTO article = new BoardDTO();
						article.setNum(rs.getInt("num"));//�Խù� ��ȣ�� �ҷ��´�. 
						article.setWriter(rs.getString("writer"));
						article.setEmail(rs.getString("email"));
						article.setSubject(rs.getString("subject"));
						article.setPasswd(rs.getString("passwd"));
						article.setContent(rs.getString("content"));
						article.setIp(rs.getString("ip"));
						
						article.setRegdate(rs.getTimestamp("reg_date"));//�ۼ���¥ (���ó�¥)
						article.setReadcount(rs.getInt("readcount")); //��ȸ��
						
						//-----------------���----------------
						article.setRef(rs.getInt("ref")); //�׷��ȣ
						article.setRe_step(rs.getInt("re_step")); //�亯�� ����
						article.setRe_level(rs.getInt("re_level")); //�亯�� ���� 
						//-------------------------------------
						
						article.setContent(rs.getString("content"));
						article.setIp(rs.getNString("ip"));
						
						//�߰��ϱ�
						articleList.add(article); //���� ���ڵ���� articleList�� �߰�����. 
					}while(rs.next());
				}
			}catch(Exception e) {
				System.out.println("getArticles()�޼��� ȣ�� ���� =>" + e);
			}
			finally{//3. �޸� ����, ����
				pool.freeConnection(con, pstmt, rs); //con.close(), pstmt.close(), rs.close()
			}
			return articleList; //list.jsp���� articleList�� for���� ���� ����.
	}
	
	
	
	//�۾���
	//insert into board values()
	public void insertArticle(BoardDTO article) {
		//�޾ƾ��ϴ� �Ű������� ���� ������ BoardDTO�� article�̶�� �̸����� �޾ƿ´�.
		//writePro.jsp���� ȣ���ϴµ� �űԱ����� �亯������ ��� Ȯ���� �ұ�? => article�� ������ Ȯ���Ѵ�.
		int num = article.getNum();//�Խñ۹�ȣ ---> �űԱ��̳� �亯���̳� ������ ����
		int ref = article.getRef();
		int re_step = article.getRe_step();
		int re_level = article.getRe_level();
		//���̺� �Է��� �Խù� ��ȣ�� ������ ����
		int number = 0; //--> �����͸� �ֱ� ���� �ʿ�
		System.out.println("insertArticle�޼����� ������ num=>" + num);
		System.out.println("ref=>"+ ref + ", re_step=>" + re_step + ", re_level=>" + re_level);
		
	///�Խù� ��ȣ + 1 -> �������� �Խñ��� ���� ��ȣ�� +1�� �Ǵ� ��.
		try {
			con = pool.getConnection(); //�׻� DB�� ���� �����Ѵ�.
			//SQL����
			sql = "select max(num) from board"; //board���� ���� ū num�� ���ؿͶ� 
			pstmt = con.prepareStatement(sql); //pstmt�� ���;� sql������ ������ �� �ִ�.
			//select�̱� ������ result���� ���´�., executeQuery()
			//insert���ٸ� executeUpdate
			rs = pstmt.executeQuery();
			
			if(rs.next()) { //���� ���̺��� �����Ͱ� �Ѱ��� �����ϸ�
				number = rs.getInt(1) + 1; //1-->�ִ밪.  +1 --> ������ ���� ���� ���ϱ� ���� +�� ��
			}else {
				number = 1; //�Խñ��� �ϳ��� ���� ���¶�� ���� ���� ���� 1�� �Ǿ�� �Ѵ�. 
			}
			
			
			//���࿡ �亯���̶��
			if(num != 0) {
				
			}else { //�űԱ��̶��
				ref=number; //ref=1,2,3,.... (�׷��ȣ���� �Խñ� ������ �Ѵ�.)
				re_step=0;
				re_level=0;
			}
			//12�� �����͸� ������ �ȴ�. �ٸ� �� �߿��� num, reg_date, readcount�� �Է� ���� �ʴ´�.
			//mysql�� ��¥�� �ۼ��� �� (now())�� ����. / SQL�� sysdate
			sql = "insert into board(writer,email,subject,passwd,reg_date,ref, re_step, re_level, content,ip)values(?,?,?,?,?,?,?,?,?,?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, article.getWriter()); //�ۼ���
			pstmt.setString(2, article.getEmail());
			pstmt.setString(3, article.getSubject());
			pstmt.setString(4, article.getPasswd());
			pstmt.setTimestamp(5, article.getRegdate());
			//article�� ������ �� �״�� ����� �� ���.
			//�̷��� ���� �����Ÿ� values(?,?...)�� �κп��� 5��°��(?,?,?,?,now(),?,?....)�� �� �� �ִ�.
			 
			//------�ڡ�ref, re_step, re_level�ڡ�
			pstmt.setInt(6, ref); //article.getRef()�� �ƴ� ref��� �� ����!  => �߰��� �ű�, �亯�ۿ� ���� ���� ����Ǳ� ����
			pstmt.setInt(7, re_step);
			pstmt.setInt(8, re_level);
			//------------------------------------------
			
			pstmt.setString(9,article.getContent()); //�� ���� �״�� �ҷ��´�.
			pstmt.setString(10,article.getIp()); //request.getRemoteAddr(); --> Ŭ���̾�Ʈ�� ip�� ������ ���
			
			int insert = pstmt.executeUpdate(); //sql���� insert�̱� ������ executeUpdate()!
			System.out.println("�Խ����� �۾��� ��������(insert)=>" + insert);
			
		}catch(Exception e) {
			System.out.println("insertArticle()�޼��� ���� ����=>" + e);
		}finally {
			pool.freeConnection(con, pstmt, rs);
		}
	}
}
