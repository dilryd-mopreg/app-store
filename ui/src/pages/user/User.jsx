import Urbit from '@urbit/http-api';
import React, { useEffect, useState } from 'react';
import mockApi from "../../../mocks/dev-view.json";
import { AppTile } from '../../components/AppTile';
import { SearchBar } from '../../components/SearchBar';
import { Sidebar } from '../../components/Sidebar';

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

// TODO(adrian): Add api call from ship to get applications
export function User(props) {
  const [apps, setApps] = useState([]);

  useEffect(() => {
    subscribe();
    setApps(getApplications());
  }, []);

  const subscribe = async () => {
    try {
      api.subscribe({
        app: "usr-server",
        path: "/render",
        event: handleUpdate,
        err: () => setErrorMsg("Subscription rejected"),
        quit: () => setErrorMsg("Kicked from subscription"),
        cancel: () => setErrorMsg("Subscription cancelled"),
      });
    } catch {
      setErrorMsg("Subscription failed");
    }
  };

  const handleUpdate = (upd) => {
    console.log(upd);
  }

  const setErrorMsg = (msg) => { throw new Error(msg); };

  // This will be an async function to make the calls to urbit ship.
  const getApplications = () => {
    return Object.keys(mockApi);
  }

  return (
      <div className='flex flex-row'>
        <Sidebar />
        <main className="basis-3/4 flex items-center w-full justify-center min-h-screen">
          <div className="w-4/5 space-y-6 py-14">
            <h1 className="text-3xl font-bold">My applications</h1>
            <SearchBar />
            {apps.length && (
              <ul className="space-y-4">
                { Object.entries(apps).map((applicationName) =>
                    <AppTile key={applicationName[1]} {...mockApi[applicationName[1]]} />
                  ) }
              </ul>
            )}
          </div>
      </main>
      </div>
  );
}