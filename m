Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF35F14177A
	for <lists+linux-bcache@lfdr.de>; Sat, 18 Jan 2020 13:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgARMfG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 18 Jan 2020 07:35:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:46070 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728872AbgARMfG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 18 Jan 2020 07:35:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 33734ADDF;
        Sat, 18 Jan 2020 12:35:04 +0000 (UTC)
Subject: Re: undo make-bcache (was: Re: Can't mount an encrypted backing
 device)
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
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <43edbec0-d29f-dcdb-2cf3-791a937a3090@suse.de>
Date:   Sat, 18 Jan 2020 20:34:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CA+Z73LFpXFOcWNzn3nMN7kCWjzUa0myQiOc+tozFbNZGemxXhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/1/18 8:22 下午, Clodoaldo Neto wrote:
> On Sat, Jan 18, 2020 at 7:54 AM Clodoaldo Neto
> <clodoaldo.pinto.neto@gmail.com> wrote:
>>
>> On Thu, Jan 16, 2020 at 9:59 PM Coly Li <colyli@suse.de> wrote:
>>>
>>> On 2020/1/17 5:52 上午, Clodoaldo Neto wrote:
>>>>
>>>> Em seg, 13 de jan de 2020 11:19, Coly Li <colyli@suse.de
>>>> <mailto:colyli@suse.de>> escreveu:
>>>>>
>>>>> On 2020/1/13 8:44 下午, Jens-U. Mozdzen wrote:
>>>>>> Hi Coly,
>>>>>>
>>>>>> jumping in here, because I was looking for a way to revert from bcache
>>>>>> to plain device:
>>>>>>
>>>>>> Zitat von Coly Li <colyli@suse.de <mailto:colyli@suse.de>>:
>>>>>>> The super block location of the backing disk is occupied by bcache. You
>>>>>>> cannot mount the file system directly from the backing disk which is
>>>>>>> formated as bcache backing device [...] (bcache offset all I/Os on
>>>>>>> bcache device 4KB behind the requesting
>>>>>>> LBA on backing disk).
>>>>>>
>>>>>> Assuming that no caching device is associated with a backing device (so
>>>>>> the backing device is "clean" as in "containing all data blocks with the
>>>>>> current content"), could one convert the content of a backing device to
>>>>>> a "non-bcached device" by removing the first 4096 octets of the backing
>>>>>> device content?
>>>>>>
>>>>>> Something like "dd if=backingdev of=newdev skip_bytes=4096 ..."?
>>>>>
>>>>> Hi Jens-U,
>>>>>
>>>>> you may try dmsetup to setup a linear device mapper target, and the map
>>>>> table just skipping the first 4KB (bcache superblock area). If you are
>>>>> lucky, I mean the real file system is not corrupted, the created device
>>>>> mapper target can be mounted directly.
>>>>
>>>>
>>>> I'm trying dmsetup but it does not accept anything other than 0 and 0
>>>> at the beginning and end of the table:
>>>>
>>>> # echo '0 3774578672 linear /dev/mapper/backing-device 8' | dmsetup
>>>> create dmb
>>>> device-mapper: reload ioctl on dmb  failed: Invalid argument
>>>> Command failed.
>>>
>>> The above line should work, if 3774578672 is a correct size number in
>>> sectors.
>>
>> I took it from the original map:
>>
>> # dmsetup table /dev/mapper/backing-device
>> 0 3774578672 crypt aes-xts-plain64
>> :64:logon:cryptsetup:7e2c0b40-8dec-4b13-8d00-b53b55160775-d0 0 251:0
>> 32768
> 
> It works like this:
> 
> # echo '0 3774578664 linear /dev/mapper/backing-device 8' | dmsetup create dmb
> 
> But then I can't mount it:
> 
> # mount /dev/mapper/dmb /r
> mount: /r: wrong fs type, bad option, bad superblock on
> /dev/mapper/dmb, missing codepage or helper program, or other error.

It might be my fault, from bcache-tools, it seems the offset is
BDEV_DATA_START_DEFAULT (16 sectors). How about:
# echo '0 3774578656 linear /dev/mapper/backing-device 16' | dmsetup
create dmb


-- 

Coly Li
