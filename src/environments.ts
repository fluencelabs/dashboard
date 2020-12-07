export type Node = { peerId: string; multiaddr: string };

export const stage: Node[] = [
    {
        multiaddr: '/dns4/stage.fluence.dev/tcp/19001/wss/p2p/12D3KooWEXNUbCXooUwHrHBbrmjsrpHXoEphPwbjQXEGyzbqKnE9',
        peerId: '12D3KooWEXNUbCXooUwHrHBbrmjsrpHXoEphPwbjQXEGyzbqKnE9',
    },
    {
        multiaddr: '/dns4/stage.fluence.dev/tcp/19002/wss/p2p/12D3KooWHk9BjDQBUqnavciRPhAYFvqKBe4ZiPPvde7vDaqgn5er',
        peerId: '12D3KooWHk9BjDQBUqnavciRPhAYFvqKBe4ZiPPvde7vDaqgn5er',
    },
    {
        multiaddr: '/dns4/stage.fluence.dev/tcp/19003/wss/p2p/12D3KooWBUJifCTgaxAUrcM9JysqCcS4CS8tiYH5hExbdWCAoNwb',
        peerId: '12D3KooWBUJifCTgaxAUrcM9JysqCcS4CS8tiYH5hExbdWCAoNwb',
    },
    {
        multiaddr: '/dns4/stage.fluence.dev/tcp/19004/wss/p2p/12D3KooWJbJFaZ3k5sNd8DjQgg3aERoKtBAnirEvPV8yp76kEXHB',
        peerId: '12D3KooWJbJFaZ3k5sNd8DjQgg3aERoKtBAnirEvPV8yp76kEXHB',
    },
    {
        multiaddr: '/dns4/stage.fluence.dev/tcp/19005/wss/p2p/12D3KooWCKCeqLPSgMnDjyFsJuWqREDtKNHx1JEBiwaMXhCLNTRb',
        peerId: '12D3KooWCKCeqLPSgMnDjyFsJuWqREDtKNHx1JEBiwaMXhCLNTRb',
    },
    {
        multiaddr: '/dns4/stage.fluence.dev/tcp/19990/wss/p2p/12D3KooWMhVpgfQxBLkQkJed8VFNvgN4iE6MD7xCybb1ZYWW2Gtz',
        peerId: '12D3KooWMhVpgfQxBLkQkJed8VFNvgN4iE6MD7xCybb1ZYWW2Gtz',
    },
    {
        multiaddr: '/dns4/stage.fluence.dev/tcp/19100/wss/p2p/12D3KooWPnLxnY71JDxvB3zbjKu9k1BCYNthGZw6iGrLYsR1RnWM',
        peerId: '12D3KooWPnLxnY71JDxvB3zbjKu9k1BCYNthGZw6iGrLYsR1RnWM',
    },
];

// net01.fluence.dev       /ip4/165.227.164.206/tcp/9001/ws        12D3KooWEXNUbCXooUwHrHBbrmjsrpHXoEphPwbjQXEGyzbqKnE9
// net01.fluence.dev       /ip4/165.227.164.206/tcp/9990/ws        12D3KooWMhVpgfQxBLkQkJed8VFNvgN4iE6MD7xCybb1ZYWW2Gtz
// net01.fluence.dev       /ip4/165.227.164.206/tcp/9100/ws        12D3KooWPnLxnY71JDxvB3zbjKu9k1BCYNthGZw6iGrLYsR1RnWM
// net02.fluence.dev       /ip4/138.197.189.50/tcp/9001/ws         12D3KooWHk9BjDQBUqnavciRPhAYFvqKBe4ZiPPvde7vDaqgn5er
// net03.fluence.dev       /ip4/157.230.23.49/tcp/9001/ws          12D3KooWBUJifCTgaxAUrcM9JysqCcS4CS8tiYH5hExbdWCAoNwb
// net04.fluence.dev       /ip4/159.65.126.102/tcp/9001/ws         12D3KooWJbJFaZ3k5sNd8DjQgg3aERoKtBAnirEvPV8yp76kEXHB
// net05.fluence.dev       /ip4/142.93.169.49/tcp/9001/ws          12D3KooWCKCeqLPSgMnDjyFsJuWqREDtKNHx1JEBiwaMXhCLNTRb
// net06.fluence.dev       /ip4/139.59.148.53/tcp/9001/ws          12D3KooWKnRcsTpYx9axkJ6d69LPfpPXrkVLe96skuPTAo76LLVH
// net07.fluence.dev       /ip4/206.81.30.129/tcp/9001/ws          12D3KooWBSdm6TkqnEFrgBuSkpVE3dR1kr6952DsWQRNwJZjFZBv
// net08.fluence.dev       /ip4/157.230.98.51/tcp/9001/ws          12D3KooWGzNvhSDsgFoHwpWHAyPf1kcTYCGeRBPfznL8J6qdyu2H
// net09.fluence.dev       /ip4/159.89.2.70/tcp/9001/ws            12D3KooWF7gjXhQ4LaKj6j7ntxsPpGk34psdQicN2KNfBi9bFKXg
// net10.fluence.dev       /ip4/157.230.98.75/tcp/9001/ws          12D3KooWB9P1xmV3c7ZPpBemovbwCiRRTKd3Kq2jsVPQN4ZukDfy

export const faasNet: Node[] = [
    {
        multiaddr: '/ip4/165.227.164.206/tcp/9001/ws/p2p/12D3KooWEXNUbCXooUwHrHBbrmjsrpHXoEphPwbjQXEGyzbqKnE9',
        peerId: '12D3KooWEXNUbCXooUwHrHBbrmjsrpHXoEphPwbjQXEGyzbqKnE9',
    },
    {
        multiaddr: '/ip4/165.227.164.206/tcp/9990/ws/p2p/12D3KooWMhVpgfQxBLkQkJed8VFNvgN4iE6MD7xCybb1ZYWW2Gtz',
        peerId: '12D3KooWMhVpgfQxBLkQkJed8VFNvgN4iE6MD7xCybb1ZYWW2Gtz',
    },
    {
        multiaddr: '/ip4/138.197.189.50/tcp/9001/ws/p2p/12D3KooWHk9BjDQBUqnavciRPhAYFvqKBe4ZiPPvde7vDaqgn5er',
        peerId: '12D3KooWHk9BjDQBUqnavciRPhAYFvqKBe4ZiPPvde7vDaqgn5er',
    },
    {
        multiaddr: '/ip4/157.230.23.49/tcp/9001/ws/p2p/12D3KooWBUJifCTgaxAUrcM9JysqCcS4CS8tiYH5hExbdWCAoNwb',
        peerId: '12D3KooWBUJifCTgaxAUrcM9JysqCcS4CS8tiYH5hExbdWCAoNwb',
    },
    {
        multiaddr: '/ip4/159.65.126.102/tcp/9001/ws/p2p/12D3KooWJbJFaZ3k5sNd8DjQgg3aERoKtBAnirEvPV8yp76kEXHB',
        peerId: '12D3KooWJbJFaZ3k5sNd8DjQgg3aERoKtBAnirEvPV8yp76kEXHB',
    },
    {
        multiaddr: '/ip4/142.93.169.49/tcp/9001/ws/p2p/12D3KooWCKCeqLPSgMnDjyFsJuWqREDtKNHx1JEBiwaMXhCLNTRb',
        peerId: '12D3KooWCKCeqLPSgMnDjyFsJuWqREDtKNHx1JEBiwaMXhCLNTRb',
    },
    {
        multiaddr: '/ip4/139.59.148.53/tcp/9001/ws/p2p/12D3KooWKnRcsTpYx9axkJ6d69LPfpPXrkVLe96skuPTAo76LLVH',
        peerId: '12D3KooWKnRcsTpYx9axkJ6d69LPfpPXrkVLe96skuPTAo76LLVH',
    },
    {
        multiaddr: '/ip4/206.81.30.129/tcp/9001/ws/p2p/12D3KooWBSdm6TkqnEFrgBuSkpVE3dR1kr6952DsWQRNwJZjFZBv',
        peerId: '12D3KooWBSdm6TkqnEFrgBuSkpVE3dR1kr6952DsWQRNwJZjFZBv',
    },
    {
        multiaddr: '/ip4/157.230.98.51/tcp/9001/ws/p2p/12D3KooWGzNvhSDsgFoHwpWHAyPf1kcTYCGeRBPfznL8J6qdyu2H',
        peerId: '12D3KooWGzNvhSDsgFoHwpWHAyPf1kcTYCGeRBPfznL8J6qdyu2H',
    },
    {
        multiaddr: '/ip4/159.89.2.70/tcp/9001/ws/p2p/12D3KooWF7gjXhQ4LaKj6j7ntxsPpGk34psdQicN2KNfBi9bFKXg',
        peerId: '12D3KooWF7gjXhQ4LaKj6j7ntxsPpGk34psdQicN2KNfBi9bFKXg',
    },
    {
        multiaddr: '/ip4/157.230.98.75/tcp/9001/ws/p2p/12D3KooWB9P1xmV3c7ZPpBemovbwCiRRTKd3Kq2jsVPQN4ZukDfy',
        peerId: '12D3KooWB9P1xmV3c7ZPpBemovbwCiRRTKd3Kq2jsVPQN4ZukDfy',
    },
];

export const faasNetHttps: Node[] = [
    {
        multiaddr: '/dns4/net01.fluence.dev/tcp/19001/wss/p2p/12D3KooWEXNUbCXooUwHrHBbrmjsrpHXoEphPwbjQXEGyzbqKnE9',
        peerId: '12D3KooWEXNUbCXooUwHrHBbrmjsrpHXoEphPwbjQXEGyzbqKnE9',
    },
    {
        multiaddr: '/dns4/net01.fluence.dev/tcp/19990/wss/p2p/12D3KooWMhVpgfQxBLkQkJed8VFNvgN4iE6MD7xCybb1ZYWW2Gtz',
        peerId: '12D3KooWMhVpgfQxBLkQkJed8VFNvgN4iE6MD7xCybb1ZYWW2Gtz',
    },
    {
        multiaddr: '/dns4/net02.fluence.dev/tcp/19001/wss/p2p/12D3KooWHk9BjDQBUqnavciRPhAYFvqKBe4ZiPPvde7vDaqgn5er',
        peerId: '12D3KooWHk9BjDQBUqnavciRPhAYFvqKBe4ZiPPvde7vDaqgn5er',
    },
    {
        multiaddr: '/dns4/net03.fluence.dev/tcp/19001/wss/p2p/12D3KooWBUJifCTgaxAUrcM9JysqCcS4CS8tiYH5hExbdWCAoNwb',
        peerId: '12D3KooWBUJifCTgaxAUrcM9JysqCcS4CS8tiYH5hExbdWCAoNwb',
    },
    {
        multiaddr: '/dns4/net04.fluence.dev/tcp/19001/wss/p2p/12D3KooWJbJFaZ3k5sNd8DjQgg3aERoKtBAnirEvPV8yp76kEXHB',
        peerId: '12D3KooWJbJFaZ3k5sNd8DjQgg3aERoKtBAnirEvPV8yp76kEXHB',
    },
    {
        multiaddr: '/dns4/net05.fluence.dev/tcp/19001/wss/p2p/12D3KooWCKCeqLPSgMnDjyFsJuWqREDtKNHx1JEBiwaMXhCLNTRb',
        peerId: '12D3KooWCKCeqLPSgMnDjyFsJuWqREDtKNHx1JEBiwaMXhCLNTRb',
    },
    {
        multiaddr: '/dns4/net06.fluence.dev/tcp/19001/wss/p2p/12D3KooWKnRcsTpYx9axkJ6d69LPfpPXrkVLe96skuPTAo76LLVH',
        peerId: '12D3KooWKnRcsTpYx9axkJ6d69LPfpPXrkVLe96skuPTAo76LLVH',
    },
    {
        multiaddr: '/dns4/net07.fluence.dev/tcp/19001/wss/p2p/12D3KooWBSdm6TkqnEFrgBuSkpVE3dR1kr6952DsWQRNwJZjFZBv',
        peerId: '12D3KooWBSdm6TkqnEFrgBuSkpVE3dR1kr6952DsWQRNwJZjFZBv',
    },
    {
        multiaddr: '/dns4/net08.fluence.dev/tcp/19001/wss/p2p/12D3KooWGzNvhSDsgFoHwpWHAyPf1kcTYCGeRBPfznL8J6qdyu2H',
        peerId: '12D3KooWGzNvhSDsgFoHwpWHAyPf1kcTYCGeRBPfznL8J6qdyu2H',
    },
    {
        multiaddr: '/dns4/net09.fluence.dev/tcp/19001/wss/p2p/12D3KooWF7gjXhQ4LaKj6j7ntxsPpGk34psdQicN2KNfBi9bFKXg',
        peerId: '12D3KooWF7gjXhQ4LaKj6j7ntxsPpGk34psdQicN2KNfBi9bFKXg',
    },
    {
        multiaddr: '/dns4/net10.fluence.dev/tcp/19001/wss/p2p/12D3KooWB9P1xmV3c7ZPpBemovbwCiRRTKd3Kq2jsVPQN4ZukDfy',
        peerId: '12D3KooWB9P1xmV3c7ZPpBemovbwCiRRTKd3Kq2jsVPQN4ZukDfy',
    },
];
