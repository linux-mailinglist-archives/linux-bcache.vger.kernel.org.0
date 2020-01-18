Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE599141808
	for <lists+linux-bcache@lfdr.de>; Sat, 18 Jan 2020 15:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgARObq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 18 Jan 2020 09:31:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:38550 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgARObq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 18 Jan 2020 09:31:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 28CBDAE2B;
        Sat, 18 Jan 2020 14:31:44 +0000 (UTC)
Subject: Re: undo make-bcache (was: Re: Can't mount an encrypted backing
 device)
From:   Coly Li <colyli@suse.de>
To:     clodoaldo.pinto.neto@gmail.com
Cc:     "Jens-U. Mozdzen" <jmozdzen@nde.ag>, linux-bcache@vger.kernel.org
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de>
 <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
 <0c6c3fea-5580-3a71-264c-b383b5b4fe66@suse.de>
 <CA+Z73LGG1pBtT=0WN5vEyqEvzxEnqMRZ26S_2x4Gd5JPSmuXmQ@mail.gmail.com>
 <CA+Z73LFNxP8kDMSq74DBKDbCXpbtMA9svpc1KddkUmrk-cfnOA@mail.gmail.com>
 <CA+Z73LGXJOwYEb+GmPuuDi3TcJbGG=NLv-5vCRcEvB+kgr4a+A@mail.gmail.com>
 <32fb3244-cb9e-460d-3156-99e418dda44f@suse.de>
 <CA+Z73LE8GEHqvsFqNuQ3+aSbSmC93D68zd+gTw8Hk=78RjUj7A@mail.gmail.com>
 <CA+Z73LFpXFOcWNzn3nMN7kCWjzUa0myQiOc+tozFbNZGemxXhA@mail.gmail.com>
 <43edbec0-d29f-dcdb-2cf3-791a937a3090@suse.de>
 <CA+Z73LEuZCw6EHG386jZrqUKuqGw0E8z+nEvrNmLQ0NLzh9+kw@mail.gmail.com>
 <abfeedfa-f973-de4e-3b54-53d1502af939@suse.de>
Organization: SUSE Labs
Message-ID: <073b1b48-2d2c-369f-114e-5b608ffea683@suse.de>
Date:   Sat, 18 Jan 2020 22:31:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <abfeedfa-f973-de4e-3b54-53d1502af939@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/1/18 10:16 下午, Coly Li wrote:

>>>> It works like this:
>>>>
>>>> # echo '0 3774578664 linear /dev/mapper/backing-device 8' | dmsetup create dmb
>>>>
>>>> But then I can't mount it:
>>>>
>>>> # mount /dev/mapper/dmb /r
>>>> mount: /r: wrong fs type, bad option, bad superblock on
>>>> /dev/mapper/dmb, missing codepage or helper program, or other error.
>>>
>>> It might be my fault, from bcache-tools, it seems the offset is
>>> BDEV_DATA_START_DEFAULT (16 sectors). How about:
>>> # echo '0 3774578656 linear /dev/mapper/backing-device 16' | dmsetup
>>> create dmb
>>
>> Still no luck
>>
>> # echo '0 3774578656 linear /dev/mapper/backing-device 16' | dmsetup create dmb
>> # mount /dev/mapper/dmb /r
>> mount: /r: wrong fs type, bad option, bad superblock on
>> /dev/mapper/dmb, missing codepage or helper program, or other error.
> 
> The tricky part is to calculate the correct linear mapping size.
> 
> For example, I have a 500G hard drive, from fdisk I see its size is
> 1048576000 sectors. I use it as a bcache backing device and format an
> Ext4 file system on it. Then I use the following mistaken command line
> to setup a linear target to skip the first 8 sectors,
>  # echo '0 1048575000  linear /dev/sdc 16' | dmsetup create dmb
> Then mount /dev/mapper/dmb to /mnt fails, the kmesg hints me,
>  [1884572.477316] EXT4-fs (dm-0): bad geometry: block count 131071998
> exceeds size of device (131071875 blocks)
> 
> So I realize Ext4 file system will check the block device size, so I
> need to provide an exact accurate length number for the linear target.
> From the kmesg I see the correct sector size should be
> (131071998*8=)1048575984, then I re-create the linear target by,
>  # echo '0 1048575984  linear /dev/sdc 16' | dmsetup create dmb
> Then I mount /dev/mapper/dmb to /mnt, it works and I have the following
> line from command 'mount',
>  /dev/mapper/dmb on /mnt type ext4 (rw,relatime)
> 
> I don't use the encrpyt file system and I don't know the excact detail
> about it. But I guess, it might because the incorrect length number for
> your dm linear target as I show by the above example.
> 

Sorry I realize maybe I mislead you....

I re-read the first email, it seems you create the bcache backing device
on top of a raid raid1, then you cryptsetup on the bcache device.

So I guess the linear dm target should be created on top of the md
raid1, not /dev/mapper/backing-device. Which might be,
# echo '0 3774578656 linear /dev/md127 16' | dmsetup create dmb

The above line assumes luks has its superblock on offset zero from its
own LBA, and <0 3774578656> should be a correct pair.

If all the offset numbers are correct, dmb should be the block device
for your to run cryptsetup open. Then you will have a
/dev/mapper/backing-device for following mount.

-- 

Coly Li
