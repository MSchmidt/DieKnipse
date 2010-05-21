package models.valueObjects
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;

	public class Frame extends EventDispatcher
	{
		[Bindable]
		public var bitmapData:BitmapData;
		[Bindable]
		public var id:int;
		[Bindable]
		public var duration:Number;
		
		public function Frame(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}