package models
{	
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	public class Config extends EventDispatcher
	{
		private static var _instance:Config;
		[Bindabel]
		public static function get i():Config
		{
			if( _instance == null ) _instance = new Config( new SingletonEnforcer() );
			return _instance;
		}
		
		[Bindable]
		public var camWidth:int=600;
		[Bindable]
		public var camHeight:int=375;
		[Bindable]
		public var defaultDuration:Number=1000;
		
		
		public function Config(pvt:SingletonEnforcer)
		{
		}
	}
}

internal class SingletonEnforcer{}