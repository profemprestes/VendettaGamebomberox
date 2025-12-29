'use client'

import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
  } from "@/components/ui/select"
  import { useEffect, useState } from "react"
  
  export function ClientSelect() {
    const [isClient, setIsClient] = useState(false)
  
    useEffect(() => {
      setIsClient(true)
    }, [])
  
    return (
        <>
         {isClient && (
            <Select defaultValue="34:13:129">
                <SelectTrigger className="w-auto h-6 text-xs bg-white border-stone-400 focus:ring-0">
                    <SelectValue/>
                </SelectTrigger>
                <SelectContent>
                    <SelectItem value="34:13:129">34:13:129</SelectItem>
                </SelectContent>
            </Select>
         )}
        </>
    )
  }
  