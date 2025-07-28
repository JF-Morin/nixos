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

    let getActiveWorkspace = function (){
        //return hyprland.get_workspace()
    }

    const [workspaces, setWorkspaces] = createState(getSortedWorkspaces())
    const [activeWorkspaceId, setActiveWorkspaceId] = createState(999)



    hyprland.connect('event', (service, eventName, data) => {
        //print(`Received Hyprland event: ${eventName}, with data: ${data}`);

        if(eventName == "workspacev2"){
            setWorkspaces(getSortedWorkspaces())
            setActiveWorkspaceId(data[0])
        }
    });
    
    const activeWsId = activeWorkspaceId((id)=>id.toString() )


    return (
        <box class="bar-widget" orientation={Gtk.Orientation.HORIZONTAL}>
            <For each={workspaces}>
                {(item, index: Accessor<number>) => (
                    <button class='workspace-active'>
                        <label halign={Gtk.Align.Center} label={item.id.toString()}/>
                    </button>
                )}
            </For>
            <label label={activeWsId}/>
        </box>
    )
}
