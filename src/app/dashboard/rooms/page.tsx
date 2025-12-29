import { roomsData } from "./rooms-data";
import { RoomCard } from "./room-card";

export default function RoomsPage() {
  return (
    <div className="space-y-4">
      <div className="bg-primary text-primary-foreground text-center py-2 rounded-sm">
        <h1 className="text-lg font-bold">Habitación</h1>
      </div>
      {roomsData.map((room) => (
        <RoomCard key={room.id} room={room} />
      ))}
    </div>
  );
}