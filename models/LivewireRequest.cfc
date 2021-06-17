/**
 * Represents an subsequent, incoming Livewire XHR Request from the browser.
 */
component singleton{
    
    /**
     * Injected ColdBox controller which we will use to access our app and module settings
     */
    property name="controller" inject="coldbox";

    /**
     * Injected WireBox because DI rocks.
     */
    property name="wirebox" inject="wirebox";

    /**
     * Injected RequestService so that we can access the current ColdBox RequestContext.
     */
    property name="requestService" inject="coldbox:requestService";

    /**
     * Returns the current ColdBox RequestContext event.
     *
     * @return RequestContext
     */
    function getEvent() {
        return variables.requestService.getContext();
    }

    /**
     * Returns true if our request context contains a 'fingerprint' property.
     * 
     * @return Boolean
     */
    function hasFingerprint() {
        return structKeyExists( this.getCollection(), "fingerprint" );
    }  

    /**
     * Returns true if our request context contains a 'serverMemo' property.
     * 
     * @return Boolean
     */
    function hasServerMemo() {
        return structKeyExists( this.getCollection(), "serverMemo" );
    }

    /**
     * Returns true if our server memo contains a mounted state property.
     * 
     * @return Boolean
     */
    function hasMountedState(){
        return this.hasServerMemo() && structKeyExists( this.getServerMemo(), "mountedState" );
    }

    /**
     * Returns our mounted state
     * 
     * @return Struct
     */
    function getMountedState(){
        return this.getServerMemo()[ "mountedState" ];
    }

    /**
     * Returns the serverMemo from our request context.
     * 
     * @return struct
     */
    function getServerMemo() {
        return this.getCollection()[ "serverMemo" ];
    }

    /**
     * Returns true if our request context contains an 'updates' property.
     * 
     * @return Boolean
     */
    function hasUpdates() {
        return structKeyExists( this.getCollection(), "updates" );
    }

    /**
     * Returns an array of LivewireUpdate objects with our updates from the request context.
     * 
     * @return Array | LivewireUpdate
     */
    function getUpdates() {
        return this.getCollection()[ "updates" ].map( function( update ) {
            return variables.wirebox.getInstance( name="cbLivewire.models.LivewireUpdate", initArguments={ update: arguments.update } );
        } );
    }

    /**
     * Returns our event's public request collection.
     * 
     * @return Struct
     */
    function getCollection() {
        return getEvent().getCollection( argumentCollection=arguments );
    }

    /**
     * Returns our event's private request collection.
     * 
     * @return Struct
     */
    function getPrivateCollection() {
        return getEvent().getPrivateCollection( argumentCollection=arguments );
    }

    /**
     * Finds and returns our Livewire component by name, either using
     * module syntax Component@Module or root sytax, which looks
     * in the root "livewire" folder.
     *
     * @componentName String | The name of the component.
     */
    function withComponent( componentName ) {
        if ( reFindNoCase( "livewire\.", arguments.componentName ) ) {
            arguments.componentName = reReplaceNoCase( arguments.componentName, "livewire\.", "", "one" );
        }

        if( find( "@", arguments.componentName ) ){
            // This is a module reference, find in our module
            return getModuleComponent( arguments.componentName );
        } else {
            // Look in our root folder for our Livewire component
            return getRootComponent( arguments.componentName );
        }
    }

    /**
     * Instantiates our Livewire component, mounts it,
     * and then calls it's internal $renderIt() method.
     *
     * @componentName String | The name of the component in your Livewire folder.
     * @parameters Struct | The parameters you want mounted initially.
     * 
     * @return Component
     */
	function renderIt( componentName, parameters = {} ){
		return withComponent( arguments.componentName )
            .$mount( arguments.parameters )
            .$renderIt();
	}

    /**
     * Returns a cbLivewire component using the root "HelloWorld" convention.
     * 
     * @componentName String | Name of the cbLivewire component.
     * 
     * @return Component
     */
    private function getRootComponent( required componentName ) {
        var appMapping = variables.controller.getSetting( "AppMapping" );
        var livewireRoot = ( len( appMapping ) ? appMapping & "." : "" ) & "livewire";
        return variables.wirebox.getInstance( "#livewireRoot#.#arguments.componentName#");
    }

    /**
     * Returns a cbLivewire component using the module convention.
     * 
     * @componentName String | Name of the cbLivewire component and module. Ex. HelloWorld@MODULE
     * 
     * @return Component
     */
    private function getModuleComponent( required componentName ) {
        throw(message="Need to finish implementing this");
        // Verify the module
        variables.modulesConfig.keyExists( moduleName ); //else throw exception
        // Instantion Prefix of the module
        var livewireModuleRoot = variables.modulesConfig[ moduleName ].invocationPath & ".livewire"
    }

}