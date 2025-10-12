import { Astal, Gtk, Gdk } from "ags/gtk4"
import { With, For, Accessor, createState } from "ags"
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

    let getActiveWorkspace = function (){
        //return hyprland.get_workspace()
    }

    const [workspaces, setWorkspaces] = createState(getSortedWorkspaces())
    const [activeWorkspaceId, setActiveWorkspaceId] = createState(0)



    hyprland.connect('event', (service, eventName, data) => {

        if(eventName == "workspacev2"){
            setWorkspaces(getSortedWorkspaces())
            setActiveWorkspaceId(Number(data[0]))
            //print(`Received Hyprland event: ${eventName}, with data: ${data[0]}`);
            let test = activeWorkspaceId(value => value)
            print(typeof test)
        }
    });


    return (
        <box class="bar-widget" orientation={Gtk.Orientation.HORIZONTAL}>
            <For each={workspaces}>
                {(item, index: Accessor<number>) => (
                        <button class="workspace-indicator">
                            <label halign={Gtk.Align.Center} label={typeof (activeWorkspaceId(value => value))}/>
                        </button>
                )}
            </For>
        </box>
    )
}
