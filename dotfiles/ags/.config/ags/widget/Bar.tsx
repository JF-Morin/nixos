import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import  Left  from "./Left"
import  Center  from "./Center"
import  Right  from "./Right"

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
            <centerbox orientation={Gtk.Orientation.HORIZONTAL}>
                <Left $type="start" />
                <Center $type="center" />
                <Right $type="end" />
            </centerbox>
    </window>
  )
}
