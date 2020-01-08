package Game;

import java.awt.event.*;

public class GameRepaintController implements ActionListener{
	private GameModel model;
	private GameView view;
	
	/**
	 * @param model the model of this Froggor game
	 * @param view the view of this Froggor game
	 */
	public GameRepaintController(GameModel model, GameView view) {
		this.model = model;
		this.view = view;
	}
	
	/**
	 * Perform the needed actions when the timer goes off.
	 * When the timer goes off, determine XXXXXXXXXXXXXXX positions
	 * and XXXXXXXXXXXXXX logic
	 * and repaint the window.
	 */
	public void actionPerformed(ActionEvent event) {
		
		view.repaint();
	}
}
