package{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.media.Sound;

 //used for ENTER_FRAME event
	

	public class Main extends MovieClip{
		const speed:int = 10;//speed of the snake
		var Chow:Sound = new Undo_Eat();
		var BM:Sound=new musicB();
		var score:int;
		var lol:int;
		var mok:int;
		var gFood:Food;
		var sec:SnakePart;
		var SnakeDirection:String;
		var snake:Array;
		var limit:FullBoundry;
		



		public function Main(){
			init();
		}
		function init():void {
			//Initialize everything!
			
			BM.play();
			lol = 1; mok = 0;
			score = 0;
			snake = new Array();
			SnakeDirection = "";
			//puts the fooed on the stage
			addFood();
			//add snakes sec to the stage
			sec = new SnakePart();
			sec.x = stage.stageWidth/2;
			sec.y = stage.stageHeight/2;
			snake.push(sec);
			addChild(sec);
			
			stage.addEventListener(KeyboardEvent.KEY_UP , onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN , onKeyDown);
			addEventListener(Event.ENTER_FRAME , onEnterFrame);
			//ENTER_FRAME listener is attached to main class and not to the stage directly
		}
		//This function will add food to the stage
		function addFood():void {
			gFood = new Food();
			gFood.x = 50 + Math.random()*(stage.stageWidth-100);
			gFood.y = 50 + Math.random()*(stage.stageHeight-100);
			addChild(gFood);
		}
		function addBoundry():void{
			limit=new FullBoundry();
			limit.x=0;
			limit.y=0;
			
		}
		// reset the game
		function reset():void {
			score=0;
			addBoundry();
			removeChild(gFood);
			
			addFood();
			sec.x = stage.stageWidth/2;
			sec.y = stage.stageHeight/2;
			lol = 1;mok = 0;
			
			for(var i = snake.length-1;i>0;--i){
				removeChild(snake[i]);
				snake.splice(i,1);
			}
		}
		function onKeyDown(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.LEFT){
			   SnakeDirection = "left";
			}else if (event.keyCode == Keyboard.RIGHT) {
			   SnakeDirection = "right";
			}else if (event.keyCode == Keyboard.UP) {
				SnakeDirection = "up";
			}else if (event.keyCode == Keyboard.DOWN) {
				SnakeDirection = "down";
			}
		}
		function onKeyUp(event:KeyboardEvent):void {
			if(event.keyCode == Keyboard.LEFT) {
				SnakeDirection = "";
			}else if(event.keyCode == Keyboard.RIGHT) {
			    SnakeDirection = "";
			}else if(event.keyCode == Keyboard.UP ) {
				SnakeDirection = "";
			}else if(event.keyCode == Keyboard.DOWN){
				SnakeDirection = "";
			}
		}
		function onEnterFrame(event:Event):void {
			//setting direction of velocity
			if(SnakeDirection == "left" && lol != 1) {
				lol = -1;
				mok = 0;
			}else if(SnakeDirection == "right" && lol != -1) {
				lol = 1;
				mok = 0;
			}else if(SnakeDirection == "up" && mok != 1) {
				lol = 0;
				mok = -1;
			}else if(SnakeDirection == "down" && mok != -1) {
				lol = 0;
				mok = 1;
			}
			
			//collison with stage
			if(sec.x - sec.width/2 <= 0){
				score = 0;
				reset();
			}
			if(sec.x + sec.width/2 >= stage.stageWidth){
				score = 0;
				reset();
			}
			if(sec.y - sec.height/2 <= 0){
				score = 0;
				reset();
			}
			if(sec.y + sec.height/2 >= stage.stageHeight){
				score = 0;
				reset();
			}
			//move body of the snake
			for(var i = snake.length-1;i>0;--i){
				snake[i].x = snake[i-1].x;
				snake[i].y = snake[i-1].y;
			}
			//changing the position of snake's sec
			sec.x += lol*speed;
			sec.y += mok*speed;
			//collision with tail
			for(var i = snake.length-1;i>=1;--i){
				if(snake[0].x == snake[i].x && snake[0].y == snake[i].y){
					score=0;
					reset();
					break;
				}
			}
			//collision with food
			if(sec.hitTestObject(gFood)){
				score += 1;
				removeChild(gFood);
				addFood();
				var bodyPart = new SnakePart();
				bodyPart.x = snake[snake.length - 1].x;
				bodyPart.y = snake[snake.length - 1].y;
				snake.push(bodyPart);
				addChild(bodyPart);
				Chow.play();
			}
			
			//display scores
			txtScore.text = String(score);
		}
	}
}
