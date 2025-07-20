import { Astal, Gtk, Gdk } from "ags/gtk4"
import { For, Accessor, createState } from "ags"
import Hyprland from "gi://AstalHyprland"

export default function Workspaces() {
    const hyprland = Hyprland.get_default()

    let getSortedWorkspaces = function () {
        let workspaces = hyprland.get_workspaces().sort ((a,b) => {
            if(a.id < b.id) return -1 
            if(a.id > b.id) return 1  
            return 0
        })
        return workspaces
    }

    const [workspaces, setWorkspaces] = createState(getSortedWorkspaces())

    hyprland.connect('workspace-added', () => {
        let ws = getSortedWorkspaces()
        setWorkspaces(ws)
    })
    hyprland.connect('workspace-removed', () => { 
        let ws = getSortedWorkspaces()
        setWorkspaces(ws)
    })


    return (
        <box class="bar-widget" orientation={Gtk.Orientation.HORIZONTAL}>
            <For each={workspaces}>
                {(item, index: Accessor<number>) => (
                <label class="workspace-button" label={item.name} />
                )}
            </For>
        </box>
    )
}
