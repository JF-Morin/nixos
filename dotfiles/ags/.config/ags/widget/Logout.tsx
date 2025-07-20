import { Astal, Gtk, Gdk } from "ags/gtk4"
import { execAsync } from "ags/process"

export default function Logout() {

    let wlogout = function () {
        execAsync("wlogout")
    }

    return (
        <button name="power-button" class="bar-widget" onClicked={wlogout}>
            <label label=""/>
        </button>
    )
}

