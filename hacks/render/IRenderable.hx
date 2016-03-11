package hacks.render;

/**
 * Any 'thing' that can be drawn by a camera.
 * @author oscarcs
 */
interface IRenderable 
{
	public function draw(p:Panel, c:Camera):Void;
}