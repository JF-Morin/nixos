import { Astal, Gtk, Gdk} from "ags/gtk4"
import { For, Accessor, createState } from "ags"
import Hyprland from "gi://AstalHyprland"

export default function Workspaces() {
    // Get hyprland
    const hyprland = Hyprland.get_default()

    // Updates the list of Widgets
    let updateWorkspaces = function(activeId: number) {
        let workspaces = new Array()
        let currentWsAdded = false
        const orderedWorkspaces = hyprland.get_workspaces().sort((a,b) => a.id - b.id)

        // Loop through every Workspace
        orderedWorkspaces.forEach( ws =>{
            let item: any

            // Label for the current Workspace
            if(ws.id == activeId && !currentWsAdded) {
                item = (
                    <label class='workspace-indicator'/>
                )
                currentWsAdded = true
            }
            // Button for other workspaces (navigation)
            else {
                item = (
                    <button class='workspace-active'>
                        <label halign={Gtk.Align.CENTER}/>
                    </button>
                )
            }

            // Add to list to return
            workspaces.push(item)
        })
        return workspaces
    }
    
    const [workspaces, setWorkspaces] = createState(updateWorkspaces(0))

    hyprland.connect('event', (service, eventName, data) => {

        // In case of new workspace
        if(eventName == "workspacev2"){
            setWorkspaces(updateWorkspaces(data[0]))
        }
    });

    // Widget to return
    return (
        <box class="bar-widget" orientation={Gtk.Orientation.HORIZONTAL}>
            <For each={workspaces}>
                {(item, index: Accessor<number>) => (
                    item
                )}
            </For>
        </box>
    )
}
