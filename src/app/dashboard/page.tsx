import { Changelog } from './changelog'
import { Notices } from './notices'

export default async function DashboardPage() {
  return (
    <div className="grid grid-cols-1 gap-8">
      <Changelog />
      <Notices />
    </div>
  )
}
