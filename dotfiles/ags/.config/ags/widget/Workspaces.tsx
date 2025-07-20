import { Astal, Gtk, Gdk } from "ags/gtk4"
import { For, Accessor } from "ags"
import Hyprland from "gi://AstalHyprland"

export default function Workspaces() {
    const hyprland = Hyprland.get_default()
    let sortedWorkspaces = new Accessor<Hyprland.Workspace>()

    //hyprland.connect('workspace-added',)

    let getSortedWorkspaces = function () {
        let workspaces = hyprland.get_workspaces().sort ((a,b) => {
            if(a.id < b.id) return -1 
            if(a.id > b.id) return 1  
            return 0
        })
    }

    return (
        <box orientation={Gtk.Orientation.HORIZONTAL}>

        </box>
    )
}
