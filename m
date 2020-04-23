Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF1D1B5E61
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Apr 2020 16:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgDWOyV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Thu, 23 Apr 2020 10:54:21 -0400
Received: from mail01.bih.net.ba ([80.65.86.242]:27731 "EHLO mail01.bih.net.ba"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgDWOyV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Apr 2020 10:54:21 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Apr 2020 10:54:19 EDT
IronPort-PHdr: =?us-ascii?q?9a23=3AEZyAjRwwxd5X78XXCy+O+j09IxM/srCxBDY+r6Qd?=
 =?us-ascii?q?1+oQIvad9pjvdHbS+e9qxAeQG9mCtrQY2qGI7ejJYi8p2d65qncMcZhBBVcuqP?=
 =?us-ascii?q?49uEgeOvODElDxN/XwbiY3T4xoXV5h+GynYwAOQJ6tL1LdrWev4jEMBx7xKRR6?=
 =?us-ascii?q?JvjvGo7Vks+7y/2+94fcbglVhDexe7x/IRG5oQjQt8QdnJdvJLs2xhbVuHVDZv?=
 =?us-ascii?q?5YxXlvJVKdnhb84tm/8Zt++ClOuPwv6tBNX7zic6s3UbJXAjImM3so5MLwrhnM?=
 =?us-ascii?q?URGP5noHXWoIlBdDHhXI4wv7Xpf1tSv6q/Z91SyHNsD4Ubw4RTKv5LptRBPvlS?=
 =?us-ascii?q?kIKyQ28GTXi8Bpi6xbpxShqAJ/woXJZI2YOuZycr/Ycd4cWGFPXNteVzZZD42y?=
 =?us-ascii?q?b4UPFekPM/tXoIbhqFUOrBywBRW3CePz0z9HmmP60Lcm3+kjFwzNwQwuH8gJsH?=
 =?us-ascii?q?TRtNj4KLodUf6yzKnL1zrDc+5d1yrn54jObB8hpeuDVq9+f8rQzUkgDB3Kjk+X?=
 =?us-ascii?q?qYz7PjOayvwCvW+c7+p7SeKgkXQnpBltrzey2McsjYrJiZgJyl/c6Ct22oA1Ks?=
 =?us-ascii?q?O8SEFhedGqHppQtyWBOIRoWMMiRH9ouCcmxbYbvpC7ezMKyIg9yB7FdveKdJKH?=
 =?us-ascii?q?7Q/9VOaWIjd3nm5ldKiiiBaz9Uiv0fPzVtOz0FZUrypKjsLBuWsM1xzT8MSHTO?=
 =?us-ascii?q?Vy/lu71TmUzQ/e8+dJKl03m6rDM5Mt36I8moAOvUjfAiP6gkr7gaCMekk5++Wk?=
 =?us-ascii?q?9/zrbqj6qpOGKoN4lh3yPr4hl8GwG+g0LwcDU3Wd9O+hzrPs51f5T69PjvAul6?=
 =?us-ascii?q?nZt43VKtoDq66iBg9Vzp4j6xGiDze6yNgYnWcILFZCeB+fiojpJ0vBLOnlAful?=
 =?us-ascii?q?mFuskTdry+rAPrL/HpXBNGPMn635cbZ87U5T1hYzwMhC655IEL0NPe7/VlPruN?=
 =?us-ascii?q?HXARI1KRG4zuf7BNll04MRQ2OPAquXMKPItl+I4/oiLPORa48Lvzb9KOIq5+L0?=
 =?us-ascii?q?gXAkmF8debKm0oUNaHC/APRmIlmWbGH3jdcAEWcGpAw+Q/L2iFGYSjFcfW6+X7?=
 =?us-ascii?q?gg6TEjFIKmEYDDS5isgLyH0ie7GYZbZmNACl+SEHfob52EV+4SaC2MOM9ujD0E?=
 =?us-ascii?q?Vb64R48/yx6urhL1xKRhLubO5yIXq4rp1MJp6O3LiREy6Tt0AtyT0m6TVG50m3?=
 =?us-ascii?q?kHRyQq3K9hu0xw0VSD0a9kjPNGE9xT++lFXRokOpTE1ex1F8jyWh7dfteOUFum?=
 =?us-ascii?q?Q9OmAT82Tt8qwN8OflhyFMmijh/d2SqmGr8Vl7uFBJwx6K3c2X7xK9xgxHnYzK?=
 =?us-ascii?q?MhlUUpQtNTNW26ga5y7wvTB4nPk0WFjamqdrgc0TXJ9GeEzGuCplxXXxBoW6Xf?=
 =?us-ascii?q?QX8fflfWrcj+5k7aTr+uD7onMgxaxM6GJKpGc9LpjVBdS/fjItjRf2Wxm2KoDx?=
 =?us-ascii?q?aS2ryMdJbqe3ka3CjFEEgEjhsc/XKHNQciHiehp3jRAyBwGlL0eE7s9PNxp2+9?=
 =?us-ascii?q?TkAqwQCKdFdt2Ker9RQNn/yTV+sT3q4YuCcmszh7B0yy38jKC9uAvAdheb9TYd?=
 =?us-ascii?q?I54FtdyWLZsBR9PoSnL6BjgF4ebx57sF7w2B9vEIVPjdAqrG82zAp1Ma+Z3lRB?=
 =?us-ascii?q?dzeW3ZD/ILLXLGby8Aqra67Lx17f3teW+qgU5fQ9sVrjvQWpGVEl83RoydVVz2?=
 =?us-ascii?q?ac6ozXAwoIT53xSVs4+AZ8p73AfyYy+Zve1WdwPqmsrj/Cx9UpCfM+yha9Z9df?=
 =?us-ascii?q?KKSEFBXuE8ABAsihMvcql0K0YR0aJOpS7rI7P9u6d/ua366mJOlgnDO9jWtZ5I?=
 =?us-ascii?q?ByyFiA9yliRe7TxJYK3fWY3hGGVzf6g1esqcX3mYdAZT4MEWuz0zTrBIlUZqdq?=
 =?us-ascii?q?Z4YEFX+uI9GrxtV5n5PtWGBX9Fu4B1Ma2M6pfQSdYkf43Q1L00Qbu2ComSy9zz?=
 =?us-ascii?q?ZsiTEmsrKf3DDSw+TlbBcHJHRERG1njVftO4i0is4VXFOxbwg0lRul+Vz1yrNe?=
 =?us-ascii?q?pKRkKWnfW1tHfy/zL2t6SKu/qqKCY9JT6JMvqShXTOO8bkubSrHnuBsVyz3sEH?=
 =?us-ascii?q?BaxD8lbDyqv4j5kAJ8iG2BLHZ8snzZddh1xRjF5dzcQeRd0ScYSyNgkznYGkC8?=
 =?us-ascii?q?P8W1/dWTj5rDt/qxV2S8VpJNdSnk15iNtC6m5WJ0Bx2wg/CzlcPhEQQjyi/7ys?=
 =?us-ascii?q?NqVSvSoBnhfIbhz766Pv5/fkl0GF/87NJ3GoB4kos+g5Edwn0ahoiO/XoGkmfz?=
 =?us-ascii?q?NMtU1r//bHUXXzIE3sDa6hD/2EJ/NnKJ2575VnKFz8R7etm6eWcW1Tg7789XEa?=
 =?us-ascii?q?uU6L1EnSVpolejqwLdeOZ9kSkHyfs18nEahfwGtBAwwSqDGroSB1VXPTTwlxSU?=
 =?us-ascii?q?6NCztKVXa3ypcbirzUZ+n9ehA6uerQFcWXb5f40uHTdt7sV7NFLN3nzz6p34eN?=
 =?us-ascii?q?TLa9IcqAGUnAvHj+hRL5IxmfwKijR9NW3go3Iv0/Q7ggB23ZGmoIiHLH1g/KSl?=
 =?us-ascii?q?DRJBMz31Zt8c+jHzgqZahcaZxY+iE45nGjoVQJvnUfWoEDYVtfToMQaBDicwpW?=
 =?us-ascii?q?qFFrDHBw+Q9F9mr27TE5CsL3yXIH4ZzdJhRBSGIkxfgRwbXDY6n5M2CwCm3tHu?=
 =?us-ascii?q?f1lh7DAL+lH4sgdMyv5vNxTnU2ffogmoajAvRZiZKxpW9BxN50jIMcyb6+JzHj?=
 =?us-ascii?q?tU8YC/owaVMGyUexxIDX0VWkyDH13jP7+u5dfH8+WDHuqxMefObquUqeBHVPeI?=
 =?us-ascii?q?2Iyg0pN+/zmSLMWPJWNuAOAl1UBbR3B2B9zZmykTSywQjy/NbsibpBm7+iBsts?=
 =?us-ascii?q?C/8e/rWB7o5YuVCrtSLM5v9wmtgaeCKeGQnj15KTJG2ZwX23DIzqIT00MMhCt2?=
 =?us-ascii?q?bTmiDawAtTLRTKLXgqJXEQAUazlwNMRS8qI80BJAOdbcitPxzLF4lOc5BEpbWl?=
 =?us-ascii?q?z8hsGpftAFI2G5NFzdAkaEKa6KKiDVzMvve6OzVaVQjPlItx23oTubEknjPjqE?=
 =?us-ascii?q?lzTyTxCvNv1MjD2bPBxZtoG9fA9hCWviTN34cB27K8d3giMszbIpmHzALXQcPi?=
 =?us-ascii?q?Rkc0NRsr2Q6jtVjehlFGxO4XplLPKJmzyD4OnFNpYZr/1rAiRumOJH+3Q20ada?=
 =?us-ascii?q?7CZBRPZtgivdssZuo026kumI0jdoShxOpStRhI2Vp0piIr7U9oNeVnbf4BIC93?=
 =?us-ascii?q?iQCw4QqNtjFt3jorhQy9jVlK3pLTdC8s/b8tUGC8fJNs2NKGAhPgbxGD7IEAsF?=
 =?us-ascii?q?SiamNX3Eh0FGivGS8GGVooInpZfygJAOUKNUVEQpFvMGDURoBN0CIJF5XjMjir?=
 =?us-ascii?q?Obl9QH5Xy/rBnNXspVoIzHVumSAfr1NTaZlqBIZxQVwbPkNosTLIr71FF4ZlZn?=
 =?us-ascii?q?govAA1DQUsxVoi19cg80p11A/2JjQWIpxk3oZQ2g72QUFf+0hR47kRB+bv8x+z?=
 =?us-ascii?q?fj51c3IUHFqzE0kEUrn9XqnyyReibrLKisRYFWFzb0t08pP5PlRAZ1dxaynVB+?=
 =?us-ascii?q?OzfCWr1clKBgenxyhADCpJtPA+RTTbZfbx8N3/GXaO8k3klCpS+/309I+fPFCY?=
 =?us-ascii?q?d+lAstaZOsrnRA2wxkbNMuPqzfOKpJzkVQhqKLpCCnyuAxzxEEJ0YQ9mOdZTYI?=
 =?us-ascii?q?t1YSNrk6ISqn4PZs5RaflDRdYGIMTeYloup29kMhPOSN1yPg07hNKkC2LOGfNL?=
 =?us-ascii?q?2Wu27ems6SXlM/yF8Hm1Be/bdo18csblSbV0YvzLuWDRQJLtbCJRtIYMVM7HLT?=
 =?us-ascii?q?ZzqBsf3RwZJpOIWwDvvoTeqOtKYUmU+kBwMpH4QM7sgbA5ajzlnSLd37I74d1R?=
 =?us-ascii?q?Ut+APrKU2eDPRVZh2LljYGrN+7zJJsxoldPi8SAX5jPiWx/LrYuggqgP+bVtcs?=
 =?us-ascii?q?fngaRpcENm4xWMCihiFWpXJAACO50uIY0wiN8z/8qTrKDDTndNpjfPaUag12BN?=
 =?us-ascii?q?6q/jU/9rC8iUTL/ZXGO2H6KdNit8fV5uMcupmHEe1bQqNms0vGmIlYXWalU2vX?=
 =?us-ascii?q?EdGrPJXwcJIsbd/xCnqgT1OwlSo/T93tM9a1MqiInQboSJ5Ov4md3TEsK869Fj?=
 =?us-ascii?q?4AFBd2vOwD/798ahMebJo4fB7orQU+OLKlIAuCz9qhXX6nKSFKQPlH0eW6e7tX?=
 =?us-ascii?q?wjI3buCmyHsgSo81z+yy8UETXpEGlx7eyuynZ4laTyfzAGdQexnWqSo+kWhhMu?=
 =?us-ascii?q?cywuEhzx/SrFYTLSiBdPZ1Z2xco9E8GVSSLG10Cmo3XVCcl5bM4g+20L0d5CZd?=
 =?us-ascii?q?g8xb0ehdsHfkpZDQejKtVLaxqZXPqSYvcd8mo6hpO4z5PsSGrI/eniDYTJTIsw?=
 =?us-ascii?q?2FViC6F/1Bl9hMICJXWvhIlXggOcMcoopB8lA+VsggKLBWDaksp7aqZid6Ai4U?=
 =?us-ascii?q?1yMWSp2P1iQYguigw7vaiguQcJM6PRwBqppCmNgdUzNtYi8EoK+jUJvZl3OfSm?=
 =?us-ascii?q?cXIAcc8x5M5B4bm49sfuDl4ZTHTIVMyz5RrfJ0XCrLFp1s91r7UG2ZnV/4SPC5?=
 =?us-ascii?q?meyzwQ1S1O7s0sUcWBNnB0lcyehXllcyJ7xsN6kQu5TGsiKOdUP7pW7ty/GpJE?=
 =?us-ascii?q?NVyc3PbV34EYrFunTmXiIB53IeXZVPx23HFZQOjwp5b74mpFFWL4C8YUb+4Dok?=
 =?us-ascii?q?x5xyErmkT8CrxlAlrXcaRyaqFdpOFf1mvEjQWD1/bJChsI/lNIlKQm9M5J2drE?=
 =?us-ascii?q?9UkERrMy63zppRMN9N7SQVUDhAuzWdu8aySNVZ1cBrEZAGOs1/tGvlGKNYJJiR?=
 =?us-ascii?q?pGU7taf1yn/Y9DA8sUu6xCmtFKOhTOJZ5XYTGhs3KGSEsUkgFe0s/XnO8lzXr1?=
 =?us-ascii?q?974f9RBqKTgkVpvDZ9ApdOCy5X1XCiNVRzV3hGs/lbKavLdcxTXuc9ZQW0Nhwg?=
 =?us-ascii?q?G/4m21WF8V17kHvjfiN9qBNQ+zrBUAksSSkVnrDtlCUaqsGmPz8aVp1JYSw6YC?=
 =?us-ascii?q?jZMQ2UhSBXswhEZkF0VJAWHMxF96sY3YRK5MrCT1ijKSUfUBxlLAI43uJVlVRf?=
 =?us-ascii?q?v0WAZSDdEQ2oeO7Osh1xc8eRq9WkLOr9/AdAloPnsOc4+7wER32gnQ2tQNbeoJ?=
 =?us-ascii?q?HmutKXqESEbL34PPGkYX/dUDjMigi9hasjD5nM/ijeKxRbK558yXo+f5fuFG/L?=
 =?us-ascii?q?PRJJJ64BIEpbT696Y81cou9Gf89kZLoJ+ah1CxKGQBPvFouvoeJIL1nJSjTeKT?=
 =?us-ascii?q?uO8vamrYLW97PdUvTvZsyNx3bBXa13OIx15iPmG7vwzIBR5Bm+4Pp18lJGTg3j?=
 =?us-ascii?q?Oj2bodnnbiMK4sKhckbz9sksFC7MDZp2kHvrzUJEettNHwWj95Bew5RcviXeU+?=
 =?us-ascii?q?V9h2H/rupR/qUs0oAx7rRggeu1Ia3fM/NEsERQJx+PGgxwwbwhHm98TnxmWeYX?=
 =?us-ascii?q?JfPYSogYicrjsefpFqdfzRqO5+VDIY/OK1/GmcCjTD2dTRZJhgAfqDUyJAqckf?=
 =?us-ascii?q?iIh+l+QJD29qDCxksx7g3nfVY9x7d36NLfovKF?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2lmOgDGqKFe/6AsZAoqPA8MAQEBAQEBA?=
 =?us-ascii?q?QUBAQERAQEDAwEBAYF7AoFJgTCBPBAKgSCCdYN7hDKIMgMOgw6CMYpsiVkfgVs?=
 =?us-ascii?q?KAQEBAQEBAQEBHRoEAQEOdYNBJSkBCIFkEToEDQIQAQEGAQEBAQEGAwEBAQGFc?=
 =?us-ascii?q?1iCKR4BBAEBAQEDAwMBAQwBg1YyaAEVDQINGQJKEQcQW4JMgksBAQGxc4EyGgK?=
 =?us-ascii?q?FI4IwAYFPgQSBDgIoAYFkjG6BRAOFNoVCFIJLBLIbB4JImBSCSAGNRQOCeolgp?=
 =?us-ascii?q?1aHLA6BaDMaghEKCxqBHFAYn1QCNnKOMoEQAQ?=
X-IPAS-Result: =?us-ascii?q?A2lmOgDGqKFe/6AsZAoqPA8MAQEBAQEBAQUBAQERAQEDAwE?=
 =?us-ascii?q?BAYF7AoFJgTCBPBAKgSCCdYN7hDKIMgMOgw6CMYpsiVkfgVsKAQEBAQEBAQEBH?=
 =?us-ascii?q?RoEAQEOdYNBJSkBCIFkEToEDQIQAQEGAQEBAQEGAwEBAQGFc1iCKR4BBAEBAQE?=
 =?us-ascii?q?DAwMBAQwBg1YyaAEVDQINGQJKEQcQW4JMgksBAQGxc4EyGgKFI4IwAYFPgQSBD?=
 =?us-ascii?q?gIoAYFkjG6BRAOFNoVCFIJLBLIbB4JImBSCSAGNRQOCeolgp1aHLA6BaDMaghE?=
 =?us-ascii?q?KCxqBHFAYn1QCNnKOMoEQAQ?=
X-IronPort-AV: E=Sophos;i="5.73,307,1583190000"; 
   d="scan'208";a="45006515"
Received: from unknown (HELO mta-1.bih.net.ba) ([10.100.44.160])
  by mail01-1.bih.net.ba with ESMTP; 23 Apr 2020 16:44:35 +0200
Received: from mailbox-3.bih.net.ba (unknown [10.100.44.4])
        by mta-1.bih.net.ba (Postfix) with ESMTP id C7610423ED1;
        Thu, 23 Apr 2020 16:44:38 +0200 (CEST)
Date:   Thu, 23 Apr 2020 16:44:34 +0200 (CEST)
From:   Advokat Sanela
         =?utf-8?Q?Dilberovi=C4=87_Mostar_Advokat_Sanela_Dilberovi=C4=87?=
         Mostar <advokat.dilberovic@bih.net.ba>
Reply-To: Maureen Hinckley <maureenhinckley24@aol.com>
Message-ID: <2032947328.17076.1587653074303.JavaMail.root@bih.net.ba>
Subject: =?utf-8?Q?Meine_Stiftung_spendet_Ihnen_f=C3=BC?=
 =?utf-8?Q?nfhundertf=C3=BCnfzigtausend_Dollar.?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.100.44.141]
X-Mailer: Zimbra 8.0.0_GA_5434 (zclient/8.0.0_GA_5434)
Thread-Topic: Meine Stiftung spendet Ihnen =?utf-8?Q?f=C3=BCnfhundertf=C3=BCnfzigtausend?= Dollar.
Thread-Index: 81hNzRXQQa3Kc5Cz0pyf6DfxL4X6vQ==
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



Ich bin Maureen Hinckley aus Sterling Massachusetts. Meine Stiftung spendet fünfhundertfünfzigtausend Dollar an Sie ... Kontaktieren Sie uns für weitere Informationen E-Mail: maureenhinckley24@aol.com
