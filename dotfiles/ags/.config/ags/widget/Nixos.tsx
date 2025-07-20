import { Astal, Gtk, Gdk } from "ags/gtk4"

export default function Nixos(){
    return (
        <button class="bar-widget" onClicked={(self) => console.log(self, "clicked")}>
            <label label=""/>
        </button>
    )
}
