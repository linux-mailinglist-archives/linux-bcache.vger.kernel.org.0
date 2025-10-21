Return-Path: <linux-bcache+bounces-1223-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90ECFBF46B1
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Oct 2025 04:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3685B4217B1
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Oct 2025 02:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFEBF27A904;
	Tue, 21 Oct 2025 02:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=orange.fr header.i=@orange.fr header.b="TCEHV9sJ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-75.smtpout.orange.fr [80.12.242.75])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2634D20966B
	for <linux-bcache@vger.kernel.org>; Tue, 21 Oct 2025 02:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761015508; cv=none; b=sxsgSpEDPdbQmOCUyC2gSjYYcZDsvtlUnNPga80WBF6719t2Js8CRB43/URtcet906DhOrzkqnu39ppA9pyJI6mxm7JqJpD7AmWl++q613LGV9C+xRapkyW3KDC7Td6LWPeg8OM+YlJyxcdFmgwafAZcX4f3ojJ8y7YAUuiRBjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761015508; c=relaxed/simple;
	bh=x+xZgZkz8DOXuwaNAJi91yIYU8XcxqRLb8de8I9IKh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AzwrX81EPgHeYYbpcVN/ls6pXwkmghC9uK26Zn/i/sdlhSlvbC8FwjyF1J/Fl5SiRhuuMgcWrtWXnaKsvknfd5QqRpFyYFThSMSiyFR+SWLELY7fvcyTIynZ0CCUdXn9bTOLlBhaIGGPZdEFVp6fU/+S5YMeowOdEKV1gJevJJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=orange.fr; spf=pass smtp.mailfrom=orange.fr; dkim=pass (2048-bit key) header.d=orange.fr header.i=@orange.fr header.b=TCEHV9sJ; arc=none smtp.client-ip=80.12.242.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=orange.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=orange.fr
Received: from [192.168.1.7] ([82.125.151.155])
	by smtp.orange.fr with ESMTPA
	id B2Zpv8DWRcsP0B2ZpvHcRd; Tue, 21 Oct 2025 04:58:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.fr;
	s=t20230301; t=1761015503;
	bh=X3VsuFPdyiz3knml93rxdYy5DRl5eFS1QPDHKBu2+5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=TCEHV9sJYPYn8JA1/juwaNayeIykRw72p80/jt5wr9W/2LJ3ka7ia2HZWlsNUbPDC
	 zPFyh/X4rRn/BWjo4mFKb5VTjkjPHHZK2AtkNzTIUnqOrxVpM4QvPMZ3NGO6logyUX
	 1e82N3IePBIfmqkBtCuA/3oiPud4atMtfdOSPCwBeVZKyxoChka4Zq3tud2fkpwI1Z
	 VMk8txURrwl45u3xWo6GblTwyOm2DINIWcnx1ItpxQf6Cy/dt1a28T78Ld+GHsgzML
	 iIL62b6TRuBuW3lW28L+rND1WJK0uZZ/raO79dDBfROML4oZdjdg0CMcpFaR+R4DjH
	 OGcnI9/ARrFLg==
X-ME-Helo: [192.168.1.7]
X-ME-Auth: cGllcnJlLmp1aGVuQG9yYW5nZS5mcg==
X-ME-Date: Tue, 21 Oct 2025 04:58:23 +0200
X-ME-IP: 82.125.151.155
Message-ID: <c9ce4400-8b0a-430a-a336-32d59be1ee67@orange.fr>
Date: Tue, 21 Oct 2025 04:58:21 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Discard option
To: Coly Li <colyli@fnnas.com>
Cc: linux-bcache@vger.kernel.org
References: <20251007090232.30386-1-colyli@fnnas.com>
 <050fe436-e629-4428-8e4d-33edd8985767@orange.fr>
 <745B055F-0934-4D2A-9717-DFE34300457E@fnnas.com>
Content-Language: fr, en-GB, en-US
From: Pierre Juhen <pierre.juhen@orange.fr>
In-Reply-To: <745B055F-0934-4D2A-9717-DFE34300457E@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Coli,

I assume this email is irrelevant to the patch “bcache: avoid redundant access RB tree in read_dirty”, am I correct?

Yes you are;  sorry, I picked a message and forgot to change the title

The discard option is not recommended. Indeed in next merge window I will submit a patch series to drop the discard option.

OK, I will boot on a Live USB Key to wipe the caching device and create 
a new one without discard option.

But should I keep the discard mount option in fstab for the logical 
volumes inside bcache ?

Thanks,

Regards

_______________

Le 21/10/2025 à 03:18, Coly Li a écrit :
>> 2025年10月21日 00:39，Pierre Juhen <pierre.juhen@orange.fr> 写道：
>>
>> Hi
>> I am on kernel 6.16.12.
>> I have had errors with bcache recently, And I lost my fronted 3 or 4 times :
>> oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 128: bad csum, 32768 bytes, offset 0
>> oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 64: bad csum, 22928 bytes, offset 0
>> oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 32: bad csum, 4848 bytes, offset 2
>> oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 48: bad csum, 14096 bytes, offset 0
>> oct. 20 15:37:40 pierre.juhen (udev-worker)[461]: nvme0n1p3: Process 'bcache-register /dev/nvme0n1p3' failed with exit code 1.
>> oct. 20 15:37:40 pierre.juhen kernel: bcache: prio_read() bad csum reading priorities
>> oct. 20 15:37:40 pierre.juhen kernel: bcache: bch_cache_set_error() error on 448f191c-28df-4396-bc44-14d1f77c9005: IO error reading priorities, disabling caching
>> oct. 20 15:37:40 pierre.juhen kernel: bcache: register_bcache() error : failed to register device
>>
> I assume this email is irrelevant to the patch “bcache: avoid redundant access RB tree in read_dirty”, am I correct?
>
>
>> I had to reconfigure everything after a disk problem.
>> I have been running bcache for years now, without any problems.
>> The only difference might be that I configured the frontend with the discard option.
> The discard option is not recommended. Indeed in next merge window I will submit a patch series to drop the discard option.
>
>
>> The logical volume using bcache have also a discard option in fstab.
>> The frontend is on a Samsung 980 nvme disk.
> Try not to enable discard on cache device. This option will disappear soon.
>
> I don’t know whether discard option of Samsung 980 nvme disk may change the content of discarded LBA or not, from NVMe spec, it could be zero-filled or undefined.
> Anyway in current code discard doesn’t help performance, I suggest to not enable discard and see whether the issue still shows up.
>
> My suggestion is: always use default configuration, all our test case and performance optimization are for default configurations.
>
> Thanks.
>
> Coly Li
>

