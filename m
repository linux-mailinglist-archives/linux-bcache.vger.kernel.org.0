Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C5A39B8C4
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Jun 2021 14:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhFDMK7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 4 Jun 2021 08:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbhFDMK6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Jun 2021 08:10:58 -0400
Received: from mail.thorsten-knabe.de (mail.thorsten-knabe.de [IPv6:2a01:170:101e::d43c:8be2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC069C061763
        for <linux-bcache@vger.kernel.org>; Fri,  4 Jun 2021 05:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=thorsten-knabe.de; s=dkim1; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vT7dUIAvayEjf7UOZLC+Wmk9FGzaUMCjiTH7MlyjXj8=; b=XUijPwXpuI6dW1DYJTxSkZXpSG
        Vj4mlhRb3Z3ljZcGP2IW9aJ/42cMtLIZ3755id9S1OhWJ3Y2XgfT8tA9FF4z6/9Q+VKBq0Y4WLupK
        IzbL31QdTsVpFjTV1gBoN+wSB7vkKG8hSf/7RLLDxEoH9NJ6Xk/2Osgz8JZX7DY/0RAB4uMwROecA
        JK/9YLwRzoFhx+wpn0Rtt+Ma4mdKEINJvcKpEyGq5NugI7s3wewcvv+Bjy0QU5vipkfvTdS0dpQII
        x2amZxLsqExpuK6C1XNB/wJy/7cJuyLYjAwgUHxWQH27h6XVtcKhA3Z4fDRTy55mr7MtMH+hvhb8U
        ONhhrx7Q==;
Received: from tek01.intern.thorsten-knabe.de ([2a01:170:101e:1::a00:101])
        by mail.thorsten-knabe.de with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <linux@thorsten-knabe.de>)
        id 1lp8bB-0005MV-Oq; Fri, 04 Jun 2021 14:08:59 +0200
Subject: Re: PROBLEM: bcache related kernel BUG() since Linux 5.12
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, Rolf Fokkens <rolf@rolffokkens.nl>
References: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
 <f2f917d5-330b-a5cc-cca1-fe79a32c2140@rolffokkens.nl>
 <7e3c8a62-71d4-11a7-5dd7-137c030f5aad@suse.de>
 <92f2fb24-0d19-939d-a37a-91b9c1da4ac1@thorsten-knabe.de>
 <2a37723c-bc91-351d-5b0e-e7d104f88141@rolffokkens.nl>
 <69319c4e-71fe-5c7d-955f-801fdb9d9cba@suse.de>
 <5df1c881-02e9-f951-5dbd-016a390d8d54@rolffokkens.nl>
 <709c9a11-686d-9b82-b016-e65fdca41f01@suse.de>
From:   Thorsten Knabe <linux@thorsten-knabe.de>
Message-ID: <c838fdb3-e56b-c0f1-bfeb-0f5ebf4b369d@thorsten-knabe.de>
Date:   Fri, 4 Jun 2021 14:06:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <709c9a11-686d-9b82-b016-e65fdca41f01@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Report: Content analysis details:   (0.8 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
  0.8 DKIM_ADSP_ALL          No valid author signature, domain signs all mail
 -0.0 BAYES_20               BODY: Bayes spam probability is 5 to 20%
                             [score: 0.1450]
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly.

On 6/4/21 12:35 PM, Coly Li wrote:
> On 6/4/21 5:07 PM, Rolf Fokkens wrote:
>> Hi Coly, Thorsten,
>>
>> I survived 48 hours perfectly:
>>
>> bash-5.0$ uptime
>>  10:45:53 up 2 days, 11:05,  1 user,  load average: 2.82, 3.45, 2.67
>> bash-5.0$ cat /proc/version
>> Linux version 5.12.8-200.rf.fc33.x86_64
>> (mockbuild@tb-sandbox-mjolnir.local.tbai.nl) (gcc (GCC) 10.3.1 20210422
>> (Red Hat 10.3.1-1), GNU ld version 2.35-18.fc33) #1 SMP Tue Jun 1
>> 23:10:39 CEST 2021
>> bash-5.0$
>>
>> Furthermore there are no concerning messages in the syslog.
> 
> Hi Rolf,
> 
> Thanks for your update. Which kind of applications/workload are running
> in the past 2 days ?
> 
> Coly Li
> 

No problems observed here too. Made a few (intended) reboots, ran a some
kernel builds and made a full backup during the last two days. Kernel is
now a stock 5.12.9.
Just booted the system from an USB stick (kernel here: debian
5.10.0-0.bpo.5-amd64) and performed a filesystem (ext4) check, which
reported no errors.

Thorsten

-- 
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de
