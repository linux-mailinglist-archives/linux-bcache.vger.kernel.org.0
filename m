Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABABC42B995
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Oct 2021 09:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238734AbhJMHxe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Oct 2021 03:53:34 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54554 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238709AbhJMHxc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Oct 2021 03:53:32 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AEE15222C1;
        Wed, 13 Oct 2021 07:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634111488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nvhvYT08OaBqekgPrVrQj1DDQAtPcS5s6MXS0Pvx68I=;
        b=s3y1wFhKX4teW+dk2EZJGMb99n8sq0H9hd8aKuV07ZXB74HtatOMBISZgvSw6Kz+WdT45r
        fS7FVLumcSZ6oJv5qKAQ2xg9j5PqW1+z59SUJAslCHwMlXrky6Wx2PKoJmGPHFU8gVhpl1
        AWpa22y+e9pNkampxM6cnmH5qycab9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634111488;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nvhvYT08OaBqekgPrVrQj1DDQAtPcS5s6MXS0Pvx68I=;
        b=nVLHOft2uQ23MngH/fBxeTWsZAWOHgcA9AJT3M5JWlDBcM1qPglvc1OZNQcBR9suFDzwy7
        1l+BZ1Ozbe7BcZAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 34E0A13CBE;
        Wed, 13 Oct 2021 07:51:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mSmINP6PZmG8fgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 13 Oct 2021 07:51:26 +0000
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogW1BBVENIXSBiY2FjaGU6IHJlcGxhY2Ugc25wcmlu?=
 =?UTF-8?Q?tf_in_show_functions_with_sysfs=5femit?=
To:     =?UTF-8?B?546L5pOO?= <wangqing@vivo.com>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1634095639-4227-1-git-send-email-wangqing@vivo.com>
 <AI*ALgD1Em5Q2PfGyVlLhqrx.9.1634108359294.Hmail.wangqing@vivo.com>
 <SL2PR06MB3082B818199080975B93D0B6BDB79@SL2PR06MB3082.apcprd06.prod.outlook.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <fff14784-aadf-d7b0-3aed-e2428b1a7b54@suse.de>
Date:   Wed, 13 Oct 2021 15:51:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <SL2PR06MB3082B818199080975B93D0B6BDB79@SL2PR06MB3082.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/13/21 3:39 PM, 王擎 wrote:
>>> diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
>>> index 215df32..8bec32d 100644
>>> --- a/drivers/md/bcache/sysfs.h
>>> +++ b/drivers/md/bcache/sysfs.h
>>> @@ -51,7 +51,7 @@ STORE(fn)                                                           \
>>>     #define sysfs_printf(file, fmt, ...)                                        \
>>>     do {                                                                        \
>>>          if (attr == &sysfs_ ## file)                                    \
>>> -             return snprintf(buf, PAGE_SIZE, fmt "\n", __VA_ARGS__); \
>>> +             return sysfs_emit(buf, fmt "\n", __VA_ARGS__);  \
>>>     } while (0)
>>>     
>>>     #define sysfs_print(file, var)                                              \
>> IMHO I like this change :-) BTW, for snprint() from util.h, it seems
>> only to be used by sysfs_print() in syfs.h, would you like to change it
>> to use sysfs_emit too ?
>>
>> Thanks for the patch.
>>
>> Coly Li
>>
> sysfs_print() should also be modified if size is a fixed value PAGE_SIZE,
> but here is param, it would be appreciate if you have better method.

Yes, I meant you may implement sysfs_print() by sysfs_emit() directly in 
the way as snprint() does. Then you may remove snprint() since no one 
uses it any more.

Coly Li
