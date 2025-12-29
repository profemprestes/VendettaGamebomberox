'use client';

import Image from "next/image";
import { Button } from "@/components/ui/button";
import { PlaceHolderImages } from "@/lib/placeholder-images";
import { Coins, Shell, Droplets } from "lucide-react";
import type { Room } from "./rooms-data";

type RoomCardProps = {
  room: Room;
};

const ResourceIcon = ({ type }: { type: string }) => {
    switch (type) {
        case 'Armas':
            return <Shell className="w-4 h-4 inline-block ml-1" />;
        case 'Municion':
            return <Coins className="w-4 h-4 inline-block ml-1" />;
        case 'Dolares':
            return <p className="text-lg font-bold text-green-600 inline-block ml-1">$</p>;
        default:
            return null;
    }
}

export function RoomCard({ room }: RoomCardProps) {
  const image = PlaceHolderImages.find((p) => p.id === room.image) || PlaceHolderImages.find(p => p.id === 'dark-alley');

  return (
    <div className="bg-stone-200 text-black p-4 rounded-md border border-primary/50">
      <div className="grid grid-cols-[100px_1fr_100px] gap-4 items-center">
        {image && (
          <Image
            src={image.imageUrl}
            alt={image.description}
            width={100}
            height={100}
            className="rounded"
            data-ai-hint={image.imageHint}
          />
        )}
        <div>
          <h3 className="font-bold text-lg text-primary">
            {room.name} {room.level && `(${room.level})`}
          </h3>
          <p className="text-sm my-2">{room.description}</p>
          <div className="flex items-center gap-4 text-sm">
            {Object.entries(room.costs).map(([resource, value]) => (
              <div key={resource} className="flex items-center">
                <span>{resource.charAt(0)}: {value.toLocaleString()}</span>
                <ResourceIcon type={resource} />
              </div>
            ))}
             <span>Duración: {room.duration}</span>
          </div>
        </div>
        <div className="text-center">
          {room.status === 'upgrade' && room.upgradeLevel ? (
            <div className="text-green-600 font-bold">
              <p>Ampliacion</p>
              <p>Nivel {room.upgradeLevel}</p>
            </div>
          ) : (
            <Button variant="destructive" size="sm" className="bg-accent hover:bg-accent/90">
              Inizia espansione
            </Button>
          )}
        </div>
      </div>
    </div>
  );
}