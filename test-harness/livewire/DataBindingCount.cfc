component extends="cbLivewire.models.Component" accessors="true" {

    property name="count" default="0";

    function increment() {
        variables.count += 1;
    }

    function $renderIt() {
        return this.$renderView( "_cblivewire/dataBindingCount" );
    }
}