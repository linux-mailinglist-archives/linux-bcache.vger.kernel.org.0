Return-Path: <linux-bcache+bounces-1221-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83035BF27F9
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Oct 2025 18:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24A01424DE1
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Oct 2025 16:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9683A32ED5D;
	Mon, 20 Oct 2025 16:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=orange.fr header.i=@orange.fr header.b="Pai5ocVa"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-28.smtpout.orange.fr [80.12.242.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCF832E753
	for <linux-bcache@vger.kernel.org>; Mon, 20 Oct 2025 16:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978771; cv=none; b=W05+Q4WreYAZFdwj/zazUicW2/E4DfoA/qm3v/tt/lIzKoiA0XS83eDT7QFrIqtjy1VWH1excOdehbqMQxLpcjD+m44LaMmTccxnEyNGgn28ljdwA9/a2OzlhgCHZxHe9aakv0f3/swjhjck70DywnxQhU9Ttes556W7LcC8gqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978771; c=relaxed/simple;
	bh=ZxU/BKy1rigoiF1U6BFEhs2KdfYiXtVmq6iWw04VBTY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=arCAtTrFWz+TStuD94RJiULjc5bQwmRBVmW25XlIIPS5o+3qCciUslBuL+YlfGhk3maA91QqghDcc1O3dglu7ZNkh3daHpcytaMmXxvmvKHdkBCFPPNb3ox0fBdi2Ill3h9ZGxpf0r8X32uOTFU+HC8FmYfSvjQPKxPCa49bFtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=orange.fr; spf=pass smtp.mailfrom=orange.fr; dkim=pass (2048-bit key) header.d=orange.fr header.i=@orange.fr header.b=Pai5ocVa; arc=none smtp.client-ip=80.12.242.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=orange.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=orange.fr
Received: from [192.168.1.7] ([82.125.151.155])
	by smtp.orange.fr with ESMTPA
	id At07vYJxbhT3MAt07vQhj5; Mon, 20 Oct 2025 18:44:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.fr;
	s=t20230301; t=1760978694;
	bh=5da61BWJyUZJGiv0xEr1Sb8g+Aa37ynvVcsRGH+tFIc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To;
	b=Pai5ocVaF2KDa5i1YNaQr3rCIvT/bFrUJuwYRMTmNH7397LzDMyda+PgahNrAM63K
	 YOvtncgiOHVTvc6K7oP+mRhz5Jw1ILeuKNRVHHmWUiAfqOpqXmFsIUxWCyOdLnhDIK
	 3dY1QnBW4j1Ph3z1SbMfdhsT/C/sYs7kBxTZAw3HBnXAIqsPYgbOOwd7upoiCRxHZT
	 PJR0gTFzmB6J51tOCCsKH/2RGHrPu36eZH62TsgNKWyR215lQtRmxPzMvZbKAohD24
	 Xun5Rz3sMTKHP/zxUvMsV0lpH1kODxzMP8JkTtvXuy88PTCwv9CbHRoA1vamfsHlPc
	 UQHcEm4D9bHfw==
X-ME-Helo: [192.168.1.7]
X-ME-Auth: cGllcnJlLmp1aGVuQG9yYW5nZS5mcg==
X-ME-Date: Mon, 20 Oct 2025 18:44:54 +0200
X-ME-IP: 82.125.151.155
Message-ID: <83676ed0-1645-484c-a192-3b031e269eda@orange.fr>
Date: Mon, 20 Oct 2025 18:44:51 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pierre Juhen <pierre.juhen@orange.fr>
Subject: Re: [PATCH] bcache: avoid redundant access RB tree in read_dirty
To: colyli@fnnas.com, linux-bcache@vger.kernel.org
Cc: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
References: <20251007090232.30386-1-colyli@fnnas.com>
Content-Language: fr, en-GB, en-US
In-Reply-To: <20251007090232.30386-1-colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi

I am on kernel 6.16.12.

I have had errors with bcache recently, And I lost my fronted 3 or 4 times :

oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 128: 
bad csum, 32768 bytes, offset 0
oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 64: 
bad csum, 22928 bytes, offset 0
oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 32: 
bad csum, 4848 bytes, offset 2
oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 48: 
bad csum, 14096 bytes, offset 0
oct. 20 15:37:40 pierre.juhen (udev-worker)[461]: nvme0n1p3: Process 
'bcache-register /dev/nvme0n1p3' failed with exit code 1.
oct. 20 15:37:40 pierre.juhen kernel: bcache: prio_read() bad csum 
reading priorities
oct. 20 15:37:40 pierre.juhen kernel: bcache: bch_cache_set_error() 
error on 448f191c-28df-4396-bc44-14d1f77c9005: IO error reading 
priorities, disabling caching
oct. 20 15:37:40 pierre.juhen kernel: bcache: register_bcache() error : 
failed to register device

I had to reconfigure everything after a disk problem.

I have been running bcache for years now, without any problems.

The only difference might be that I configured the frontend with the 
discard option.

The logical volume using bcache have also a discard option in fstab.

The frontend is on a Samsung 980 nvme disk.

Any hint ?

Thank you

Regards


