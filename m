Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884E3220A12
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 12:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgGOKfX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 06:35:23 -0400
Received: from [195.135.220.15] ([195.135.220.15]:58680 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgGOKfW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 06:35:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7AB14B1F7;
        Wed, 15 Jul 2020 10:35:22 +0000 (UTC)
Subject: Re: [PATCH v2 01/17] bcache: add comments to mark member offset of
 struct cache_sb_disk
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20200715054612.6349-1-colyli@suse.de>
 <20200715054612.6349-2-colyli@suse.de>
 <668b8126-6a34-7029-dea4-2ad0ecc3915e@suse.de>
 <f48d11e2-bd17-ba6e-1bc1-b496929e5e59@suse.de>
 <SN4PR0401MB3598A8BA332C0148A0494B459B7E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <8ba5d50d-5fa3-9aa3-3f82-b790a51bef9a@suse.de>
Date:   Wed, 15 Jul 2020 18:35:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <SN4PR0401MB3598A8BA332C0148A0494B459B7E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/7/15 17:08, Johannes Thumshirn wrote:
> On 15/07/2020 11:03, Coly Li wrote:
>> On 2020/7/15 14:02, Hannes Reinecke wrote:
>>> On 7/15/20 7:45 AM, Coly Li wrote:
>>>> This patch adds comments to mark each member of struct cache_sb_disk,
>>>> it is helpful to understand the bcache superblock on-disk layout.
>>>>
>>>> Signed-off-by: Coly Li <colyli@suse.de>
>>>> ---
>>>>   include/uapi/linux/bcache.h | 39 +++++++++++++++++++------------------
>>>>   1 file changed, 20 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
>>>> index 9a1965c6c3d0..afbd1b56a661 100644
>>>> --- a/include/uapi/linux/bcache.h
>>>> +++ b/include/uapi/linux/bcache.h
>>>> @@ -158,33 +158,33 @@ static inline struct bkey *bkey_idx(const struct
>>>> bkey *k, unsigned int nr_keys)
>>>>   #define BDEV_DATA_START_DEFAULT        16    /* sectors */
>>>>     struct cache_sb_disk {
>>>> -    __le64            csum;
>>>> -    __le64            offset;    /* sector where this sb was written */
>>>> -    __le64            version;
>>>> +/*000*/    __le64            csum;
>>>> +/*008*/    __le64            offset;    /* sector where this sb was
>>>> written */
>>>> +/*010*/    __le64            version;
>>>>   -    __u8            magic[16];
>>>> +/*018*/    __u8            magic[16];
>>>>   -    __u8            uuid[16];
>>>> +/*028*/    __u8            uuid[16];
>>>>       union {
>>>> -        __u8        set_uuid[16];
>>>> +/*038*/        __u8        set_uuid[16];
>>>>           __le64        set_magic;
>>>>       };
>>>> -    __u8            label[SB_LABEL_SIZE];
>>>> +/*048*/    __u8            label[SB_LABEL_SIZE];
>>>>   -    __le64            flags;
>>>> -    __le64            seq;
>>>> -    __le64            pad[8];
>>>> +/*068*/    __le64            flags;
>>>> +/*070*/    __le64            seq;
>>>> +/*078*/    __le64            pad[8];
>>>>         union {
>>>>       struct {
>>>>           /* Cache devices */
>>>> -        __le64        nbuckets;    /* device size */
>>>> +/*0b8*/        __le64        nbuckets;    /* device size */
>>>>   -        __le16        block_size;    /* sectors */
>>>> -        __le16        bucket_size;    /* sectors */
>>>> +/*0c0*/        __le16        block_size;    /* sectors */
>>>> +/*0c2*/        __le16        bucket_size;    /* sectors */
>>>>   -        __le16        nr_in_set;
>>>> -        __le16        nr_this_dev;
>>>> +/*0c4*/        __le16        nr_in_set;
>>>> +/*0c6*/        __le16        nr_this_dev;
>>>>       };
>>>>       struct {
>>>>           /* Backing devices */
>>>> @@ -198,14 +198,15 @@ struct cache_sb_disk {
>>>>       };
>>>>       };
>>>>   -    __le32            last_mount;    /* time overflow in y2106 */
>>>> +/*0c8*/    __le32            last_mount;    /* time overflow in y2106 */
>>>>   -    __le16            first_bucket;
>>>> +/*0cc*/    __le16            first_bucket;
>>>>       union {
>>>> -        __le16        njournal_buckets;
>>>> +/*0ce*/        __le16        njournal_buckets;
>>>>           __le16        keys;
>>>>       };
>>>> -    __le64            d[SB_JOURNAL_BUCKETS];    /* journal buckets */
>>>> +/*0d0*/    __le64            d[SB_JOURNAL_BUCKETS];    /* journal
>>>> buckets */
>>>> +/*8d0*/
>>>>   };
>>>>     struct cache_sb {
>>>>
>>> Common practice is to place comments at the end; please don't use the
>>> start of the line here.
>>
>> Hi Hannes,
>>
>> When I try to move the offset comment to the line end, I find it
>> conflicts with normal code comment, e.g.
>>    __le64            d[SB_JOURNAL_BUCKETS];    /* journal buckets */
>>
>> I have to add the offset comment to the line start. I guess this is why
>> ocfs2 code adds the offset comment at the line start.
>>
>> So finally I have to keep the offset comment on line start still...
> 
> Why at them at all? pahole -C or crash/gdb will show them for you if you're
> interested and if you need it in the code you can use offsetof().
> 
> I don't really see a good reason to add these comments. 
> 

You are right :-)  With pahole there is no reason for having this patch.

Thanks for the informative hint, this patch will disappear in next
version series.

Coly Li

