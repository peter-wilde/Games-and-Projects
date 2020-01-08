package Game;
import java.awt.*;
import java.io.*;
import java.awt.image.*;
import javax.imageio.*;

public class Log {
	
	private int x;
	private int y;
	private BufferedImage image;

	public Log(int x, int y) {
		try {
			this.image = ImageIO.read(new File("src/Game/log2.png"));
		} catch (IOException e) {
			e.printStackTrace();
		}
		this.x = x;
		this.y = y;
	}
	
	public void drawLog(Graphics g){
		g.drawImage(image, x, y, null);
	}
}