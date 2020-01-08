package Game;
import java.awt.event.*;


public class FroggorMenuController extends KeyAdapter implements ActionListener {
		private GameModel model;
		private GameView view;
		
		/**
		 * @param model the model of this Pong game
		 * @param view the view of this Pong game
		 */
		public FroggorMenuController(GameModel model, GameView view) {
			this.model = model;
			this.view = view;
		}
		
		/**
		 * Handle the menu item that was selected.
		 */
		public void actionPerformed(ActionEvent event) {
			String command = event.getActionCommand();
			if (command.equals("Exit")) {
				view.dispose();
				System.exit(0);
			} else if (command.equals("Pause/Continue")) {
				model.setPause(! model.getPause());
			} 
		}
		
		/**
		 * Handle the keyboard shortcut.
		 */
		public void keyTyped(KeyEvent event) {
			char c = event.getKeyChar();
			if (c == 'e' || c == 'E') {
				view.dispose();
				System.exit(0);
			} else if (c == 'p' || c == 'P') {
				model.setPause(! model.getPause());
			} 
		}

}
